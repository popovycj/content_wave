class GenerationFlow::TemplateRenderer < ApplicationService
  FORMATTERS = {
    /json/ => ->(content) { JSON.parse(content) },
    //     => ->(content) { content }
  }.freeze

  def initialize(template_path, data = {})
    @template_path = template_path
    @data = data
  end

  def call
    raise 'No template path provided' if @template_path.nil?

    template = ERB.new(File.read(@template_path))
    result = template.result_with_hash(@data)

    formatter.call(result)
  end

  private

  def formatter
    _, formatter = FORMATTERS.detect { |pattern, _| pattern.match?(@template_path.to_s) }
    formatter || FORMATTERS[//]
  end
end
