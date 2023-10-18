class GenerationFlow::ContentGenerator < ApplicationService
  attr_reader :template

  def initialize(template)
    @template = template
    raise 'No template provided' unless template
  end

  def call
    [content, description]
  end

  def data
    raise 'No data template path provided' if template.data_template_path.nil?

    @data ||= render_template(template.data_template_path)
  end

  def render_data
    @render_data ||= begin
      rd = data.fetch('render_data', {})
      openai_config = render_template(template.openai_config_template_path, rd)
      rd.merge!(GptApiService.call(openai_config)) unless openai_config.nil?
      rd
    end
  end

  def puppeteer_options
    @puppeteer_options ||= data.fetch('puppeteer_options', {})
  end

  def video_options
    @video_options ||= data.fetch('video_options', {})
  end

  private

  def content
    html = render_template(template.image_template_path, render_data)

    content_file = GenerationFlow::PuppeteerProcessor.call(html, puppeteer_options)
    return content_file unless video_options.any?

    GenerationFlow::VideoComposer.call(content_file, video_options)
  end

  def description
    render_template(template.description_template_path, render_data)
  end

  def render_template(path, data = {})
    GenerationFlow::TemplateRenderer.call(path, data) if path
  end
end
