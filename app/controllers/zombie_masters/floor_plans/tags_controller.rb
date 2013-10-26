module ZombieMasters
  module FloorPlans
    class TagsController < ApplicationController

      before_filter :load_floor_plan

      def new
        @tag = Tag.new
      end

      def create
        @tag = Tag.new(tag_params)
        if @tag.save
          redirect_to zombie_master_floor_plan_path(:current, @floor_plan)
        else
        end
      end
      
      private

      def tag_params
        params.require(:tag).permit(:x, :y)
      end

      def load_floor_plan
        
      end

    end
  end
end
