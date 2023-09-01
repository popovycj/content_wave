require 'erb'
require 'open3'

class ImageCreatorService
  attr_reader :erb_template_blob, :erb_template_data

  def initialize(erb_template_blob, erb_template_data={})
    @erb_template_blob = erb_template_blob
    @erb_template_data = erb_template_data
  end

  def generate_image_binary
    template_str = erb_template_blob.download
    template = ERB.new(template_str)

    rendered_html = template.result_with_hash(erb_template_data)

    image_binary_data, stderr_str, status = Open3.capture3(
      'wkhtmltoimage - -',
      stdin_data: rendered_html
    )

    raise "wkhtmltoimage failed: #{stderr_str}" unless status.success?

    image_binary_data
  end
end
