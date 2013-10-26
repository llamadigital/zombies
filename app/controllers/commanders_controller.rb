class CommandersController < ApplicationController
  include CommanderHelper

  before_filter :load_commander, only: :show

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
    @messager = Messager.new
  end

  private

  def commander_params
    params.require(:commander).permit(:name)
  end
end
