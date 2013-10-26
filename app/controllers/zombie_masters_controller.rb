class ZombieMastersController < ApplicationController
  include ZombieMasterHelper

  before_filter :load_zombie_master, only: :show

  def new
    @zombie_master = ZombieMaster.new
  end

  def create
    @zombie_master = ZombieMaster.new(zombie_master_params)
    if @zombie_master.save
      session[:player_id] = @zombie_master.id
      redirect_to @zombie_master
    else
      render :new
    end
  end

  def show
    @floor_plans = FloorPlan.all
  end

  private

  def zombie_master_params
    params.require(:zombie_master).permit(:name, :phone)
  end
end
