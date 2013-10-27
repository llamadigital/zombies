class AddTagIdToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :tag_id, :integer
  end
end
