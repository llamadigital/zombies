class Player < ActiveRecord::Base
  validates :name, :phone, presence: true
  has_many :items
  belongs_to :tag

  attr_accessor :tag_ref
  
  after_create do
    t = Tag.new
    t.ref = self.tag_ref
    self.tag = t
    self.save
  end

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

  def add_health(value)
    self.health = increment_to_max(health, value, 100)
  end

  def add_hunger(value)
    self.hunger = increment_to_max(hunger, value, 100)
  end

  def remove_hunger(value)
    self.hunger = decrement_to_zero(hunger, value)
  end

  def remove_health(value)
    self.health = decrement_to_zero(health, value)
  end

  def tick_health
    remove_health(1)
  end

  def tick_hunger
    remove_hunger(2)
  end

  def as_json(options={})
    super(options.merge({:methods => :type}))
  end

  def move_to!(tag)
    self.x = tag.x
    self.y = tag.y
    self.floorplan_id = tag.floorplan_id
    self.save
  end

  def infect(player_to_infect)
    if self.type == "Zombie"
      player_to_infect.type = "Zombie"
      player_to_infect.health = 0
      player_to_infect.hunger = 0
    end
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
