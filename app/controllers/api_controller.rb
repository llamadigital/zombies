class ApiController < ApplicationController
  include PlayersHelper

  protect_from_forgery except: [:tag, :bluetooth]

  def tag
    tag = Tag.find_by_ref(params[:id])
    render text: item_url(tag.item)
  end

  def bluetooth
    render text: root_url
  end
end
