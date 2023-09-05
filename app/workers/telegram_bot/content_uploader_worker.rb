require 'telegram/bot'

module TelegramBot
  class ContentUploaderWorker < ContentUploaderWorker
    def perform(chat_id, content_id)
      super content_id

      token = Rails.application.credentials.telegram[:token]

      Telegram::Bot::Client.run(token) do |bot|
        bot.api.send_message(chat_id: chat_id, text: "Content was uploaded")
      end
    end
  end
end
