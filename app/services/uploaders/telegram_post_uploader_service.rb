require 'telegram/bot'

class Uploaders::TelegramPostUploaderService
  attr_reader :file_path, :auth_data, :description

  def initialize(file_path, auth_data, description)
    @file_path = file_path
    @auth_data = auth_data
    @description = description
  end

  def call
    channel_id = auth_data['channel_id']

    Telegram::Bot::Client.run(Rails.application.credentials.telegram[:token]) do |bot|
      bot.api.send_photo(
        chat_id: channel_id,
        photo: file_path,
        caption: description,
        parse_mode: 'HTML'
      )
    end
  end
end
