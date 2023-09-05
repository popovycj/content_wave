class ContentGeneratorWorker
  include Sidekiq::Worker

  def perform(project_id, social_network_id, content_type_id)
    content_generator = ContentGeneratorService.new(project_id, social_network_id, content_type_id)
    content_datum     = content_generator.content_datum

    file_binary = content_generator.call

    content = PendingContent.new(content_datum_id: content_datum.id)
    content.file.attach(
      io: StringIO.new(file_binary),
      filename: 'video.mp4', # TODO: make it work with other content types
      content_type: 'video/mp4' # TODO: make it work with other content types
    )
    content.save!

    [content_datum.description, content_datum.tags, content.id]
  end
end
