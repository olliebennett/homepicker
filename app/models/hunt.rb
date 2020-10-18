# frozen_string_literal: true

class Hunt < ApplicationRecord
  belongs_to :creator_user, class_name: 'User'
  has_many :homes, dependent: :destroy
  has_many :hunt_memberships, dependent: :destroy

  validates :title, presence: true
  validates :creator_user, presence: true

  default_scope { order(:id) }

  auto_strip_attributes :title, squish: true
end
