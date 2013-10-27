class Tag < ActiveRecord::Base
  belongs_to :floor_plan, foreign_key: 'floorplan_id'

end
