class FloorPlan < ActiveRecord::Base
  self.table_name = 'floorplans'
  image_accessor :image
  validates :name, :image, presence: true 
  has_many :tags, foreign_key: 'floorplan_id'
end
