class Hunt < ApplicationRecord
  has_many :homes
  has_many :users, through: :hunt_members
end
