class Healthpack < Item

  def use
    player.add_health(50)
  end

end
