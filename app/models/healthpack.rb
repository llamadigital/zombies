class Healthpack < Item

  def item_name
    return 'First Aid Kit'
  end

  def use
    player.add_health(50)
  end

  def colour
    'green'
  end

end
