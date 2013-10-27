class ItemsController < ApplicationController
  include PlayersHelper

  def pickup
    item.pickup current_player
  end

  def show
    @item = Item.find(params[:id])
  end

  def use
    item.pickup current_player
    item.use

    current_player.save

    redirect_to dash_path
  end

  private

  def item_params
    params.require(:item).permit(:id)
  end

end
