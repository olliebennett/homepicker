# frozen_string_literal: true

class Rating < ApplicationRecord
  belongs_to :home
  belongs_to :user

  enum aspect: { local_area: 0, indoors: 1, garden: 2 }, _prefix: true

  validates :aspect, presence: true
  validates :score, inclusion: { in: 1..5, message: 'must be 1-5' }

  default_scope { order(:id) }
end
