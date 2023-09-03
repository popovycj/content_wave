class ContentGeneratorService
  attr_reader :content_datum, :content_type, :template

  def initialize(project_id, social_network_id, content_type_id)
    @project_id        = project_id
    @content_type_id   = content_type_id
    @social_network_id = social_network_id

    prepare_variables
  end

  def call
    return unless content_datum

    background = template.backgrounds.sample
    generator_service.new(image_binary, background).call
  end

  private

  def prepare_variables
    @content_datum ||= find_content_datum
    return unless @content_datum

    @template     = @content_datum.template
    @content_type = @content_datum.content_type
  end

  def find_content_datum
    ContentDatum.includes(:profile, :content_type, :template)
                .find_by(
                   profile: { project_id: @project_id, social_network_id: @social_network_id },
                   content_type_id: @content_type_id
                )
  end

  def generator_service
    "#{content_type.title.classify}GeneratorService".constantize
  end

  def image_binary
    ImageCreatorService.new(template.file, template_data).call
  end

  def template_data
    evaluated_template_data = process_eval_key(template.data)
    gpt_api_response = GptApiService.new(content_datum.prompt).call

    evaluated_template_data.merge(JSON.parse(gpt_api_response))
  end

  def process_eval_key(input_hash)
    return input_hash unless input_hash.key?('eval')

    new_hash = input_hash.dup
    eval_hash = new_hash.delete('eval')

    evaluated_hash = eval_hash.transform_values do |value|
      begin
        eval(value)
      rescue SyntaxError, StandardError => e
        puts "Error evaluating #{value}: #{e}"
        value
      end
    end

    new_hash.merge!(evaluated_hash)
  end
end
