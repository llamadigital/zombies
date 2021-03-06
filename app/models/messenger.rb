class Messenger
  require 'clockwork'

  attr_accessor :error

  def initialize
    key = ENV['CLOCKWORK_KEY']
    @api = Clockwork::API.new(key)
  end

  def message(to, content)
    message = @api.messages.build(to: to, content: content)
    response = message.deliver

    if response.success
      true
    else
      self.error = response.error_description
      false
    end
  end

end
