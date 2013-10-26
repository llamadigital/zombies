class Player < ActiveRecord::Base
  validates :name, :phone, presence: true

  def health=(health)
    super(health)
    handle_death
  end

  def health
    super
  end

  def tick
    if hunger > 0
      tick_hunger
    else
      tick_health
    end
  end

  def tick_hunger
    adjusted_hunger = decrement_to_zero(hunger, 4)
    self.hunger = adjusted_hunger
  end

  def tick_health
    self.health = decrement_to_zero(health, 2)
  end

private

  def decrement_to_zero(number, decrement)
    [0, number - decrement].max
  end

  def handle_death
    if health == 0 
      self.type = 'Zombie'
    end
  end

end
