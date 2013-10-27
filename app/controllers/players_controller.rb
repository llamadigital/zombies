class PlayersController < ApplicationController
  include PlayersHelper

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    @player.health = 100
    @player.hunger = 100

    if @player.save
      session[:player_id] = @player.id;
      redirect_to dash_path
    else
      render :new
    end
  end

  def show
    @player = Player.find(params[:id])
  end

  def tick
    if current_player
      current_player.tick
      current_player.save

      render json: @current_player
    end
  end

  def index
    @players = Player.where(type: nil)
  end

  def assume
    player = Player.find(params[:id])
    session[:player_id] = player.id
    redirect_to dash_path
  end

  def arrive_at_base
    current_player.hunger = 100
    render json: @current_player
  end

  private

  def player_params
    params.require(:player).permit(:name, :phone)
  end
end
