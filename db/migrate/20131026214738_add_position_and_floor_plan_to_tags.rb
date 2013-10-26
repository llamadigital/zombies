class AddPositionAndFloorPlanToTags < ActiveRecord::Migration
  def change
    add_column :tags, :x, :integer
    add_column :tags, :y, :integer
    add_column :tags, :floorplan_id, :integer
  end
end
