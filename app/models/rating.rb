class Rating < ApplicationRecord
  belongs_to :home
  belongs_to :user

  validates :aspect, presence: true
  validates :home, presence: true
  validates :score, inclusion: { in: 1..5, message: 'must be 1-5' }
  validates :user, presence: true

  default_scope { order(:id) }
end
