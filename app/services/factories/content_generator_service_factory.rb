module Factories
  class ContentGeneratorServiceFactory
    def self.build(content)
      data    = content.content_datum
      profile = data.profile

      project_id        = profile.project_id
      content_type_id   = data.content_type_id
      social_network_id = profile.social_network_id

      ContentGeneratorService.new(project_id, social_network_id, content_type_id)
    end
  end
end
