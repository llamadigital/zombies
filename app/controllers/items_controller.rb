class ItemsController < ApplicationController
  include PlayersHelper

  def pickup
    item = Item.find(params[:id])
    item.pickup! current_player
    redirect_to dash_path, notice: "Picked up #{item.item_name}"
  end

  def show
    @item = Item.find(params[:id])
    flash.now[:notice] = "You found a #{@item.item_name}"
    if @item.tag
      current_player.move_to!(@item.tag)
    end
  end

  def use
    item = Item.find(params[:id])
    item.pickup current_player
    flash[:notice] = item.use

    item.player.save
    item.destroy

    redirect_to dash_path
  end

  private

  def item_params
    params.require(:item).permit(:id)
  end

end
