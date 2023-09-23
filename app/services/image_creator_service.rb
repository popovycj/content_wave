require 'erb'
require 'open3'
require 'shellwords'

class ImageCreatorService
  attr_reader :erb_template_path, :erb_template_data, :options

  def initialize(erb_template_path, erb_template_data={}, options={ width: 1563, height: 1563 })
    @erb_template_path = erb_template_path
    @erb_template_data = erb_template_data
    @options = options
  end

  def call
    template = ERB.new(File.read(erb_template_path))
    rendered_html = template.result_with_hash(erb_template_data)

    command = "wkhtmltoimage #{command_options} - -"

    image_binary_data, stderr_str, status = Open3.capture3(
      command,
      stdin_data: rendered_html
    )

    raise "wkhtmltoimage failed: #{stderr_str}" unless status.success?

    image_binary_data
  end

  private

  def command_options
    opts = ['--enable-local-file-access']

    options.each do |key, value|
      opt_key = "--#{key.to_s.gsub('_', '-')}"
      opt_value = Shellwords.escape(value.to_s)
      opts << "#{opt_key} #{opt_value}"
    end

    opts.join(' ')
  end
end
