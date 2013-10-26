class CreateFloorplans < ActiveRecord::Migration
  def change
    create_table :floorplans do |t|
      t.string :image_uid
      t.string :image_name
      t.string :name

      t.timestamps
    end
  end
end
