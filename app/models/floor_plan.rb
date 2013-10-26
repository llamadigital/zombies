class FloorPlan < ActiveRecord::Base
  self.table_name = 'floorplans'
  image_accessor :image
  validates :name, :image, presence: true 
end
