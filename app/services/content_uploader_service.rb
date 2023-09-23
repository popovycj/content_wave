class ContentUploaderService
  # attr_reader :content, :tags, :description, :content_type_title, :file_path, :auth_data, :social_network
  attr_reader :content, :description, :content_type_title, :file_path, :auth_data, :social_network

  def initialize(content)
    @content = content

    validate_content
    prepare_variables
  end

  def call
    uploader = "Uploaders::#{social_network.capitalize}#{content_type_title.capitalize}UploaderService".constantize

    # uploader.new(file_path, auth_data, tags, description).call
    uploader.new(file_path, auth_data, description).call
  end

  private

  def validate_content
    raise 'No content provided' unless content
  end

  def prepare_variables
    template = content.template
    profile  = template.profile

    # @tags               = content.tags
    @file_path          = content.file_path
    @description        = content.description
    @auth_data          = profile.auth_data
    @social_network     = profile.social_network.title
    @content_type_title = template.content_type.title
  end
end
