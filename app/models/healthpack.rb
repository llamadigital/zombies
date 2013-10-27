class Healthpack < Item

  def item_name
    return 'First Aid Kit'
  end

  def use
    player.add_health(50)
    'You gain 50 health'
  end

  def colour
    'green'
  end

end
