class GptApiService
  attr_reader :prompt

  def initialize(prompt)
    @prompt = prompt
    @client = OpenAI::Client.new
  end

  def call
    gpt3_response
  end

  private

  def gpt3_response
    messages = [
      { role: 'system', content: @prompt['role'] },
      { role: 'user', content: @prompt['content'] }
    ]

    response = @client.chat(
      parameters: {
          model: "gpt-3.5-turbo",
          messages: messages
      })

    response.dig("choices", 0, "message", "content")
  end
end
