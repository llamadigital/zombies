class Trap < Item

  def item_name
    rand = rand(2)
    if rand > 0
      return 'First Aid Kit'
    else
      return 'Food'
    end
  end

  def use
    player.remove_health(50)
  end

  def colour
    'red'
  end

end
