class Player < ActiveRecord::Base
  validates :name, :phone, presence: true
  has_many :items

  def self.human
    where(type: nil)
  end

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

  def add_health(add_health)
    self.health = increment_to_max(health, add_health, 100)
  end

  def add_hunger(add_hunger)
    self.health = increment_to_max(hunger, add_hunger, 100)
  end

  def tick_hunger
    adjusted_hunger = decrement_to_zero(hunger, 2)
    self.hunger = adjusted_hunger
  end

  def tick_health
    self.health = decrement_to_zero(health, 1)
  end

  def as_json(options={})
    super(options.merge({:methods => :type}))
  end

private

  def decrement_to_zero(number, decrement)
    [0, number - decrement].max
  end

  def increment_to_max(number, increment, max)
    [max, number + increment].min
  end

  def handle_death
    if health == 0 
      self.type = 'Zombie'
    end
  end

end
