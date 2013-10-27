class Item < ActiveRecord::Base
  belongs_to :player
  belongs_to :tag

  def pickup(player)
    if player.type != "Zombie"
      self.player_id = player.id
    end
  end

end
