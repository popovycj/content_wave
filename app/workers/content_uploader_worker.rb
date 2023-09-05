require 'telegram/bot'

class ContentUploaderWorker
  include Sidekiq::Worker

  def perform(chat_id, content_id)
    content = PendingContent.find(content_id)
    content.upload!

    token = Rails.application.credentials.telegram[:token]

    Telegram::Bot::Client.run(token) do |bot|
      bot.api.send_message(chat_id: chat_id, text: "Content was uploaded")
    end
  end
end
