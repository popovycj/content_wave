require 'open3'

class Uploaders::TiktokShortUploaderService
  def initialize(session_id:, title:, tags:, video_binary:)
    @session_id = session_id
    @title = title
    @tags = tags
    @video_binary = video_binary
  end

  def call
    Tempfile.create(['video', '.mp4']) do |tempfile|
      tempfile.binmode
      tempfile.write(@video_binary)
      tempfile.rewind

      _stdout, stderr, status = Open3.capture3(
        "python3 lib/python/uploaders/tiktok_uploader.py -i #{@session_id} -p #{tempfile.path} -t #{@title} --tags #{@tags}"
      )

      raise "Upload failed: #{stderr}" unless status.success?
    end

    true
  end
end
