require 'telegram/bot'

task telegram_bot: :environment do
  token = Rails.application.credentials.telegram[:token]

  begin
    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        TelegramBotService.new(bot, message).process
      end
    end
  rescue Telegram::Bot::Exceptions::ResponseError => e
    puts "Telegram API Exception: #{e.message}"
    retry
  end
end
