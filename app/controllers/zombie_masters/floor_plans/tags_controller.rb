module ZombieMasters
  module FloorPlans
    class TagsController < ApplicationController

      before_filter :load_floor_plan

      def new
        @tag = Tag.new(tag_params)
        if @tag.save
          redirect_to zombie_master_floor_plan_path(:current, @floor_plan), notice: 'Tag created'
        else
          redirect_to zombie_master_floor_plan_path(:current, @floor_plan), alert: 'Problem creating tag'
        end
      end

      def show
        @tag = Tag.find(params[:id])
      end

      def destroy
        tag = Tag.find(params[:id])
        tag.destroy
        redirect_to zombie_master_floor_plan_path(:current, @floor_plan), notice: 'Tag removed'
      end

      def update
        @tag = Tag.find(params[:id])
        @tag.ref = params[:tag][:ref]
        if @tag.save
          flash.now[:notice] = 'Updated'
        else 
          flash.now[:alert] = 'Problem'
        end
        render action: :show
      end

      private

      def tag_params
        params[:tag] = {}
        params[:tag][:x] = params[:x]
        params[:tag][:y] = params[:y]
        params[:tag][:floorplan_id] = @floor_plan.id
        params.require(:tag).permit(:x, :y, :floorplan_id)
      end

      def load_floor_plan
        @floor_plan = FloorPlan.find(params[:floor_plan_id])
      end

    end
  end
end
