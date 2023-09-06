require 'open3'

class Uploaders::TiktokShortUploaderService
  attr_reader :tags, :file_path, :auth_data, :description

  def initialize(file_path, auth_data, tags, description)
    @tags        = tags
    @file_path   = file_path
    @auth_data   = auth_data
    @description = description
  end

  def call
    _stdout, stderr, status = Open3.capture3(
      "python3 lib/python/uploaders/tiktok_uploader.py -i #{session_id} -p #{file_path} -t #{description} --tags #{tags}"
    )

    raise "Upload failed: #{stderr}" unless status.success?

    true
  end

  private

  def session_id
    auth_data['session_id']
  end
end
