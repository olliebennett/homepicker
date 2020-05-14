class Hunt < ApplicationRecord
  has_many :homes
  has_one :creator_user, class_name: 'User'
  has_many :hunt_memberships
  has_many :users, through: :hunt_memberships

  default_scope { order(:id) }
end
