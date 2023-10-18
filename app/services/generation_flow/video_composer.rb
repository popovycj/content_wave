class GenerationFlow::VideoComposer < ApplicationService
  attr_reader :content_file, :audio_url

  def initialize(content_file, video_options)
    @content_file = content_file
    @audio_url = video_options['audio']
  end

  def call
    result = if File.extname(@content_file.path) == '.mp4'
               combine_audio_with_video
             else
               create_video_from_image_and_audio
             end

    content_file.unlink

    result
  end

  private

  def combine_audio_with_video
    output = Tempfile.new(['output', '.mp4'], binmode: true)

    command = [
      'ffmpeg',
      '-y',
      '-i', @content_file.path,
      '-i', @audio_url,
      '-c:v', 'copy',
      '-c:a', 'aac',
      '-strict', 'experimental',
      output.path
    ].join(' ')

    _stdout, stderr, status = Open3.capture3(command)
    raise "FFmpeg failed with error: #{stderr}" unless status.success?

    output
  end

  def create_video_from_image_and_audio
    output = Tempfile.new(['output', '.mp4'], binmode: true)

    audio_duration = `ffprobe -i #{@audio_url} -show_entries format=duration -v quiet -of csv="p=0"`.strip

    command = %W(
      ffmpeg
      -y
      -loop 1
      -i #{@content_file.path}
      -i #{@audio_url}
      -vf scale=ceil(iw/2)*2:ceil(ih/2)*2
      -c:v libx264
      -t #{audio_duration}
      -pix_fmt yuv420p
      -c:a aac
      -strict experimental
      -shortest
      #{output.path}
    )

    _stdout, stderr, status = Open3.capture3(*command)
    raise "FFmpeg failed with error: #{stderr}" unless status.success?

    output
  end
end
