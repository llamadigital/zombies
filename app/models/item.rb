class Item < ActiveRecord::Base
  belongs_to :player
  belongs_to :tag

  def pickup(player)
    if player.type != "Zombie"
      self.player_id = player.id
    end
  end

  def pickup!(player)
    pickup(player)
    save!
  end

  def usable?
    true
  end

  def pickupable?
    true
  end

end
