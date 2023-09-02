class ContentGeneratorService
  def initialize(project_id, social_network_id, content_type_id)
    @project_id        = project_id
    @content_type_id   = content_type_id
    @social_network_id = social_network_id
  end

  def call
    prepare_variables
    return unless content_datum

    background = template.backgrounds.sample
    generator_service.new(image_binary, background).call
  end

  private

  attr_reader :content_datum, :content_type, :template

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
    gpt_api_response = GptApiService.new(content_datum.prompt).call
    template.data.merge(JSON.parse(gpt_api_response))
  end
end
