require 'open3'
require 'tempfile'

class ShortGeneratorService
  attr_reader :image_binary, :video

  def initialize(image_binary, video)
    @image_binary = image_binary
    @video = video
  end

  def generate_short
  end
end
