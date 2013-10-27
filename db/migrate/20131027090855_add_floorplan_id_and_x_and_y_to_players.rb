class AddFloorplanIdAndXAndYToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :floorplan_id, :integer
    add_column :players, :x, :string
    add_column :players, :y, :string
  end
end
