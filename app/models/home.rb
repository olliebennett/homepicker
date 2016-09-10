class Home < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :images, dependent: :destroy

  validates :title, presence: true
  validates :address, presence: true
end
