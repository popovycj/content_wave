class GenerationFlow::PuppeteerProcessor < ApplicationService
  attr_reader :html, :options

  def initialize(html, options)
    @html = html
    @options = options
  end

  def call
    duration = options.delete('duration')

    return process_as_animation(duration) unless duration.nil?

    process_as_image
  end

  private

  def process_as_image
    grover = Grover.new(html, **options)

    png_file = Tempfile.new(['content', '.png'], binmode: true)
    png_file.write(grover.to_png)
    png_file
  end

  def process_as_animation(duration)
    html_file = Tempfile.new(['content', '.html'])
    html_file.write(html)
    html_file.close

    animation_output = Tempfile.new(['animation', '.mp4'], binmode: true)

    _stdout, stderr, status = Open3.capture3(
      "node lib/node/record.js '#{html_file.path}' #{duration} '#{options.to_json}' > '#{animation_output.path}'"
    )

    html_file.unlink

    raise "Command failed with error: #{stderr}" unless status.success?

    animation_output
  end
end
