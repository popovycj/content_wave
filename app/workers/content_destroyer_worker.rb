class ContentDestroyerWorker
  include Sidekiq::Worker

  def perform(content_id)
    content = PendingContent.find_by(id: content_id)
    content&.destroy
  end
end
