module ZombieMasters
  class FloorPlansController < ApplicationController
    def new
      @floor_plan = FloorPlan.new
    end

    def create
      @floor_plan = FloorPlan.new(floor_plan_params)
      if @floor_plan.save
        redirect_to zombie_master_floor_plan_path(:current, @floor_plan)
      else
        render :new
      end
    end

    def show
      @floor_plan = FloorPlan.find(params[:id])
    end

    def destroy
      @floor_plan = FloorPlan.find(params[:id])
      @floor_plan.destroy
      redirect_to zombie_master_path(:current)
    end
    
    private

    def floor_plan_params
      params.require(:floor_plan).permit(:image, :name)
    end
  end
end
