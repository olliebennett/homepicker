class Home < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :images, dependent: :destroy

  validates :title, presence: true
  validates :address_street, presence: true

  accepts_nested_attributes_for :images, reject_if: :mark_empty_images_for_destruction, allow_destroy: true

  def mark_empty_images_for_destruction(attributes)
    exists = attributes['id'].present?
    empty = attributes.except(:id).values.all?(&:blank?)
    attributes.merge!(_destroy: 1) if exists && empty # destroy empty images

    !exists && empty # reject empty attributes
  end
end
