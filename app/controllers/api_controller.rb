class ApiController < ApplicationController
  protect_from_forgery except: [:tag, :bluetooth]
  def tag
    render text: root_url
  end

  def bluetooth
    render text: root_url
  end
end
