require 'open3'
require 'tempfile'
require 'mini_magick'

class ShortGeneratorService
  def initialize(image_binary, video)
    @image_binary = image_binary
    @video = video
  end

  def call
    image_file, video_file = create_temp_files

    begin
      video_width, video_height = get_video_dimensions(video_file.path)

      desired_width = (video_width * 0.8).to_i
      desired_height = (video_height * 0.8).to_i

      actual_width, actual_height = resize_image(image_file, desired_width, desired_height)

      overlay_x = (video_width - actual_width) / 2
      overlay_y = (video_height - actual_height) / 2

      run_ffmpeg(video_file.path, image_file.path, overlay_x, overlay_y)
    ensure
      image_file.unlink
      video_file.unlink
    end
  end

  private

  def create_temp_files
    image_file = Tempfile.new(['image', '.png'], encoding: 'ascii-8bit')
    video_file = Tempfile.new(['video', '.mp4'], encoding: 'ascii-8bit')

    image_file.write(@image_binary.force_encoding('ascii-8bit'))
    video_file.write(@video.download.force_encoding('ascii-8bit'))

    image_file.close
    video_file.close

    [image_file, video_file]
  end

  def get_video_dimensions(video_path)
    cmd = "ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 #{video_path}"
    output, stderr, status = Open3.capture3(cmd)
    raise "ffprobe error: #{stderr}" unless status.success?

    video_width, video_height = output.strip.split('x').map(&:to_i)
    [video_width, video_height]
  end

  def resize_image(image_file, desired_width, desired_height)
    image = MiniMagick::Image.open(image_file.path)
    image.resize "#{desired_width}x#{desired_height}"
    image.write image_file.path

    actual_width = image.width
    actual_height = image.height

    [actual_width, actual_height]
  end

  def run_ffmpeg(video_path, image_path, overlay_x, overlay_y)
    temp_output = Tempfile.new(['temp_output', '.mp4'])
    cmd = "ffmpeg -y -i #{video_path} -i #{image_path} -filter_complex \"[0:v][1:v]overlay=#{overlay_x}:#{overlay_y}[out]\" -map \"[out]\" -map 0:a? -c:a copy #{temp_output.path}"
    _output, stderr, status = Open3.capture3(cmd)
    raise "ffmpeg error: #{stderr}" unless status.success?

    output = File.binread(temp_output.path)
    temp_output.close
    temp_output.unlink

    output
  end
end
