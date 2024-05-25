# frozen_string_literal: true

class Hunt < ApplicationRecord
  include Hashid::Rails

  belongs_to :creator_user, class_name: 'User'
  has_many :homes, dependent: :destroy
  has_many :hunt_memberships, dependent: :destroy

  validates :title, presence: true

  auto_strip_attributes :title, squish: true

  def token_match?(test_token)
    return false if test_token.blank?

    test_token.squish == join_token
  end
end
