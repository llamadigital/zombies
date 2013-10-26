class Messager
  require 'clockwork'

  def initialize
    key = ENV['CLOCKWORK_KEY']
    @api = Clockwork::API.new(key)
  end

  def message(to, content)
    message = @api.messages.build(to: to, content: content)
    response = message.deliver

    if response.success
      response.message_id
    else
      response.error_code
    end
  end

end
