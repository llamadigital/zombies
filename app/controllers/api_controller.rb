class ApiController < ApplicationController
  include PlayersHelper

  protect_from_forgery except: [:tag, :bluetooth]

  def tag
    player = Player.find_by_tag_id(params[:id])

    if player
      render text: infectshow_players_path(id: player.id)
    else
      tag = Tag.find_by_ref(params[:id])
      render text: item_url(tag.item)
    end
  end

  def bluetooth
    render text: root_url
  end

  def base
    redirect_to arrive_at_base_player_path(:current)
  end
end
