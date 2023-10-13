class ContentGeneratorService
  attr_reader :template

  def initialize(template)
    @template = template
    validate_template
  end

  def call
    [content, description]
  end

  private

  def validate_template
    raise 'No template provided' unless template
    raise 'No data template path' if template.data_template_path.nil?
  end

  def content
    generator_service.new(image_binary, random_background).call
  end

  def description
    return nil if template.description_template_path.nil?

    process_template(template.description_template_path, template_data: template_data)
  end

  def random_background
    template.backgrounds.sample
  end

  def generator_service
    @generator_service ||= "#{template.content_type.title.classify}GeneratorService".constantize
  end

  def image_binary
    ImageCreatorService.new(template.image_template_path, template_data).call
  end

  def template_data
    @template_data ||= begin
      data = process_template(template.data_template_path, is_json: true)
      openai_config = process_openai_config(data)
      data.merge!(gpt_response(openai_config)) unless openai_config.nil?
      data
    end
  end

  def process_openai_config(data)
    return nil if template.openai_config_template_path.nil?

    process_template(template.openai_config_template_path, template_data: data, is_json: true)
  end

  def process_template(template_path, template_data: {}, is_json: false)
    erb_content = File.read(template_path)
    result = ERB.new(erb_content).result_with_hash(template_data)
    is_json ? JSON.parse(result) : result
  end

  def gpt_response(openai_config)
    GptApiService.new(openai_config).call
  end
end
