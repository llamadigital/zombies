class Item < ActiveRecord::Base
  belongs_to :player

  def pickup(player)
    self.player_id = player.id
  end

end
