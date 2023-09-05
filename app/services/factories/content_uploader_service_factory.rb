module Factories
  class ContentUploaderServiceFactory
    def self.build(content)
      data    = content.content_datum
      profile = data.profile

      tags           = data.tags
      description    = data.description
      content_type   = data.content_type.title
      file_binary    = content.file.download
      auth_data      = profile.auth_data
      social_network = profile.social_network.title

      uploader = "Uploaders::#{social_network.capitalize}#{content_type.capitalize}UploaderService".constantize
      session_id = auth_data['session_id'] # TODO: get rid of this hardcode

      uploader.new(session_id, description, tags, file_binary)
    end
  end
end
