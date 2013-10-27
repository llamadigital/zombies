class BaseController < ApplicationController
  include PlayersHelper

  def index 
    @commander_items = Commander.first.items
    @player = current_player 
    @items = @player.items
  end

  def items
    items = params[:item_ids] | []
    items.each do |item|
      c = Commander.first
      c.items.push Item.find(item)
    end
      
    redirect_to base_path
  end

  private
  def base_params
    params.require(:base).permit(:item_ids)
  end
end

