require 'telegram/bot'
require 'tempfile'

class ContentGeneratorWorker
  include Sidekiq::Worker

  def perform(chat_id, project_id, social_network_id, content_type_id)
    content_generator = ContentGeneratorService.new(project_id, social_network_id, content_type_id)
    content_datum     = content_generator.content_datum

    tags         = content_datum.tags
    description  = content_datum.description
    file_binary  = content_generator.call

    content = PendingContent.new(content_datum_id: content_datum.id)
    content.file.attach(
      io: StringIO.new(file_binary),
      filename: 'video.mp4',
      content_type: 'video/mp4'
    ) # TODO: make it work with other content types
    content.save!

    tempfile = Tempfile.new(['video', '.mp4']) # TODO: make it work with other content types
    tempfile.binmode
    tempfile.write(file_binary)
    tempfile.rewind

    token = Rails.application.credentials.telegram[:token]

    Telegram::Bot::Client.run(token) do |bot|
      video_upload = Faraday::UploadIO.new(tempfile.path, 'video/mp4') # TODO: make it work with other content types

      bot.api.send_video(chat_id: chat_id, video: video_upload)

      message_text = "Description: #{description}\nTags: #{tags}"
      callback_data = "PendingContent:#{content.id}"

      button = Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Upload', callback_data: callback_data)
      inline_keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [[button]])

      bot.api.send_message(chat_id: chat_id, text: message_text, reply_markup: inline_keyboard)
    end

    tempfile.close
    tempfile.unlink
  end
end
