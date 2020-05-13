class Comment < ApplicationRecord
  belongs_to :home
  belongs_to :user

  validates :text, presence: true

  default_scope { order(:id) }
end
