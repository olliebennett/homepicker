class Home < ApplicationRecord
  has_many :comments
  has_many :images

  validates :title, presence: true
  validates :address, presence: true
end
