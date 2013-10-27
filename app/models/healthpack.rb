class Healthpack < Item

  def use
    player.health = player.health + 50
  end
end
