require 'erb'
require 'grover'

class ImageCreatorService
  attr_reader :erb_template_path, :erb_template_data, :options

  DEFAULT_OPTIONS = {
    format: 'png',
    viewport: { width: 1563, height: 1563 },
    launcher_args: ['--no-sandbox', '--disable-setuid-sandbox']
  }.freeze

  def initialize(erb_template_path, erb_template_data={}, options=DEFAULT_OPTIONS)
    @erb_template_path = erb_template_path
    @erb_template_data = erb_template_data
    @options = options
  end

  def call
    template = ERB.new(File.read(erb_template_path))
    rendered_html = template.result_with_hash(erb_template_data)

    grover = Grover.new(rendered_html, **options)
    image_binary_data = grover.to_png

    raise "Conversion failed" if image_binary_data.nil? || image_binary_data.empty?

    image_binary_data
  end
end
