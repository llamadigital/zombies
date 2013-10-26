class CommandersController < ApplicationController
  include CommanderHelper

  before_filter :load_commander, only: [:show, :message, :broadcast]

  def new
    @commander = Commander.new
  end

  def create
    @commander = Commander.new(commander_params)
    if @commander.save
      session[:player_id] = @commander.id
      redirect_to @commander
    else
      render action: :new
    end
  end

  def show
    @players = Player.where(type: nil)
  end

  def message
    @player = Player.find(params[:player_id])
    @messenger = Messenger.new
    if @messenger.message(@player.phone, params[:message])
      redirect_to @commander, notice: 'Message sent'
    else 
      redirect_to @commander, notice: @messenger.error
    end
  end

  def broadcast
    @messenger = Messenger.new
    Player.human.each do |player|
      @messenger.message(player.phone, params[:message])
    end
    redirect_to @commander, notice: 'Message broadcast'
  end

  def assume
    commander = Commander.find(params[:id])
    session[:player_id] = commander.id
    redirect_to commander
  end

  private

  def commander_params
    params.require(:commander).permit(:name, :phone)
  end
end
