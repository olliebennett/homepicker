# frozen_string_literal: true

class Hunt < ApplicationRecord
  has_many :homes
  belongs_to :creator_user, class_name: 'User'
  has_many :hunt_memberships
  has_many :users, through: :hunt_memberships

  validates :title, presence: true
  validates :creator_user, presence: true

  default_scope { order(:id) }

  auto_strip_attributes :title, squish: true
end
