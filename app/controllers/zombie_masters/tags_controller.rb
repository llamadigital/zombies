module ZombieMasters
  class TagsController < ApplicationController
    include ZombieMasterHelper 

    def new
      @tag = Tag.new
    end

    def create 
      @tag = Tag.new(tag_params)
      if @tag.save
        redirect_to zombie_master_tags_path(:current)
      else
        redirect_to zombie_master_floor_plan_path(params[:floor_plan])
      end
    end

    def edit
    end

    def update
    end

    def destroy
    end

    private

    def tag_params
      params.require(:tag)
    end
  end
end
