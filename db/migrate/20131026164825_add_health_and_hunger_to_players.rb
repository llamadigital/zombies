class AddHealthAndHungerToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :health, :integer
    add_column :players, :hunger, :integer
  end
end
