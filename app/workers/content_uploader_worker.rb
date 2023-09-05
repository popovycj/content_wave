class ContentUploaderWorker
  include Sidekiq::Worker

  def perform(content_id)
    content = PendingContent.find(content_id)
    content.upload!
  end
end
