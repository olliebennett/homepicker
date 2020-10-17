class HuntMembership < ApplicationRecord
  belongs_to :hunt, optional: false
  belongs_to :user, optional: false

  default_scope { order(:id) }
end
