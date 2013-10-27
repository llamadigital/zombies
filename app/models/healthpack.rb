class Healthpack < Item

  def use
    player.health = player.health + 50
  end

  def colour
    'green'
  end

end
