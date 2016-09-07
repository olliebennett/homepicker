class Comment < ApplicationRecord
  belongs_to :home

  validates :text, presence: true
end
