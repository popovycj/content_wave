class GptApiService
  attr_reader :config

  def initialize(config)
    @config = config
    @client = OpenAI::Client.new
  end

  def call
    gpt3_response
  end

  private

  def gpt3_response
    response = @client.chat(
      parameters: config
    )

    JSON.parse(response['choices'].first.dig('message', 'function_call', 'arguments'))
  end
end
