class Food < Item

  def use
    player.add_hunger(100)
  end

  def colour
    'green'
  end

end
