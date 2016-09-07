class Home < ApplicationRecord
  has_many :comments

  validates :title, presence: true
  validates :address, presence: true
end
