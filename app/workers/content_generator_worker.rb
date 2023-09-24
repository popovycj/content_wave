class ContentGeneratorWorker
  include Sidekiq::Worker

  def perform(project_id, social_network_id, content_type_id)
    template = find_template(project_id, social_network_id, content_type_id)

    content = template.pending_contents.create!
    content.generate!

    # [content.description, template.tags, content.id]
    [content.description, content.id]
  end

  private

  def find_template(project_id, social_network_id, content_type_id)
    Template.includes(:profile)
            .find_by(
              profile: { project_id: project_id, social_network_id: social_network_id },
              content_type_id: content_type_id
            )
  end
end
