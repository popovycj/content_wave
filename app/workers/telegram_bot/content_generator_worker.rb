require 'telegram/bot'
require 'tempfile'

module TelegramBot
  class ContentGeneratorWorker < ContentGeneratorWorker
    def perform(chat_id, project_id, social_network_id, content_type_id)
      description, tags, content_id = super(project_id, social_network_id, content_type_id)

      send_to_telegram(chat_id, description, tags, content_id)
    end

    private

    def send_to_telegram(chat_id, description, tags, content_id)
      content = PendingContent.find(content_id)
      file_binary = content.file.download

      tempfile = Tempfile.new(['video', '.mp4']) # TODO: make it work with other content types
      tempfile.binmode
      tempfile.write(file_binary)
      tempfile.rewind

      token = Rails.application.credentials.telegram[:token]

      Telegram::Bot::Client.run(token) do |bot|
        video_upload = Faraday::UploadIO.new(tempfile.path, 'video/mp4') # TODO: make it work with other content types

        bot.api.send_video(chat_id: chat_id, video: video_upload)

        message_text = "Description: #{description}\nTags: #{tags}"
        callback_data = "PendingContent:#{content_id}"

        button = Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Upload', callback_data: callback_data)
        inline_keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [[button]])

        bot.api.send_message(chat_id: chat_id, text: message_text, reply_markup: inline_keyboard)
      end

      tempfile.close
      tempfile.unlink
    end
  end
end
