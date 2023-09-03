class TelegramBotService
  def initialize(bot, message)
    @bot = bot
    @message = message
    @chat_id = derive_chat_id
  end

  def process
    send("handle_#{message.class.name.demodulize.underscore}", message) if respond_to?("handle_#{message.class.name.demodulize.underscore}", true)
  end

  private

  attr_reader :message, :chat_id, :bot

  def derive_chat_id
    return message.chat.id if message.is_a?(Telegram::Bot::Types::Message)
    return message.message.chat.id if message.is_a?(Telegram::Bot::Types::CallbackQuery)
  end

  def handle_callback_query(query)
    handle_callback(query.data)
  end

  def handle_message(message)
    case message.text
    when '/start'
      welcome_message
      display_projects
    end
  end

  def inline_keyboard(options)
    buttons = options.map do |option|
      Telegram::Bot::Types::InlineKeyboardButton.new(text: option[:text], callback_data: option[:callback_data])
    end
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: buttons.map { |button| [button] })
  end

  def welcome_message
    bot.api.send_message(chat_id: chat_id, text: "Welcome! Let's get started.")
  end

  def handle_callback(data)
    selections = data.split("|").map { |s| s.split(":") }.to_h

    project_id = selections["Project"].to_i if selections["Project"]
    social_network_id = selections["SocialNetwork"].to_i if selections["SocialNetwork"]
    content_type_id = selections["ContentType"].to_i if selections["ContentType"]

    if selections["Project"] && selections["SocialNetwork"] && selections["ContentType"]
      display_selected_ids(project_id, social_network_id, content_type_id)
    elsif selections["Project"] && selections["SocialNetwork"]
      display_content_types(social_network_id, project_id)
    elsif selections["Project"]
      display_social_networks(project_id)
    end
  end

  def display_selected_ids(project_id, social_network_id, content_type_id)
    ContentGeneratorWorker.perform_async(chat_id, project_id, social_network_id, content_type_id)

    text = "You have selected the following:\n"
    text += "Project ID: #{project_id}\n"
    text += "Social Network ID: #{social_network_id}\n"
    text += "Content Type ID: #{content_type_id}"
    text += "\n\n"
    text += "Please wait for the results to be displayed"

    bot.api.send_message(chat_id: chat_id, text: text)
  end

  def display_options(items, empty_message, selection_message, &block)
    if items.empty?
      bot.api.send_message(chat_id: chat_id, text: empty_message)
    else
      options = items.map(&block)
      markup = inline_keyboard(options)
      bot.api.send_message(chat_id: chat_id, text: selection_message, reply_markup: markup)
    end
  end

  def display_projects
    projects = Project.all

    display_options(projects, "No projects found.", "Please select a project:") do |project|
      { text: project.title, callback_data: "Project:#{project.id}" }
    end
  end

  def display_social_networks(project_id)
    project = Project.find(project_id)
    profiles = project.profiles.includes(:social_network)
    social_networks = profiles.map(&:social_network).uniq

    display_options(social_networks, "No social networks found for the selected project.", "Please select a social network:") do |sn|
      { text: sn.title, callback_data: "Project:#{project_id}|SocialNetwork:#{sn.id}" }
    end
  end

  def display_content_types(social_network_id, project_id)
    profile = Profile.find_by(social_network_id: social_network_id, project_id: project_id)
    content_types = profile.content_data.map(&:content_type).uniq

    display_options(content_types, "No content types found for the selected social network.", "Please select a content type:") do |ct|
      { text: ct.title, callback_data: "Project:#{project_id}|SocialNetwork:#{social_network_id}|ContentType:#{ct.id}" }
    end
  end
end
