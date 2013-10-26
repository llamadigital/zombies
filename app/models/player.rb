class Player < ActiveRecord::Base
  validates :name, :phone, presence: true
end
