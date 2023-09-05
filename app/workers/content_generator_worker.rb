class ContentGeneratorWorker
  include Sidekiq::Worker

  def perform(project_id, social_network_id, content_type_id)
    content_datum = find_content_datum(project_id, social_network_id, content_type_id)

    content = content_datum.pending_contents.create!

    [content_datum.description, content_datum.tags, content.id]
  end

  private

  def find_content_datum(project_id, social_network_id, content_type_id)
    ContentDatum.includes(:profile, :content_type)
                .find_by(
                   profile: { project_id: project_id, social_network_id: social_network_id },
                   content_type_id: content_type_id
                )
  end
end
