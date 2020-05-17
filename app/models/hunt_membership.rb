class HuntMembership < ApplicationRecord
  belongs_to :hunt, required: true
  belongs_to :user, required: true

  default_scope { order(:id) }
end