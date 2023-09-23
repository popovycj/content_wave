class PostGeneratorService
  attr_reader :image_binary

  def initialize(image_binary, *_)
    @image_binary = image_binary
  end

  def call
    image_binary
  end
end
