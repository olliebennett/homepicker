# frozen_string_literal: true

class HuntMembership < ApplicationRecord
  belongs_to :hunt, optional: false
  belongs_to :user, optional: false
end
