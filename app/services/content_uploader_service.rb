class ContentUploaderService
  attr_reader :content_datum, :profile, :tags, :description, :content_type, :file_path, :auth_data, :social_network

  def initialize(content_datum, profile, file_path)
    @content_datum = content_datum
    @profile = profile
    @file_path = file_path

    prepare_variables
  end

  def call
    uploader = "Uploaders::#{social_network.capitalize}#{content_type.capitalize}UploaderService".constantize

    uploader.new(file_path, auth_data, tags, description).call
  end

  private

  def prepare_variables
    @tags           = content_datum.tags
    @description    = content_datum.description
    @content_type   = content_datum.content_type.title
    @auth_data      = profile.auth_data
    @social_network = profile.social_network.title
  end
end
