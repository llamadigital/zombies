class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :player_id
      t.integer :tag_id
      t.string :type

      t.timestamps
    end
  end
end
