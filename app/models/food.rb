class Food < Item

  def item_name
    return 'Food'
  end

  def use
    player.add_hunger(100)
  end

  def colour
    'green'
  end

end
