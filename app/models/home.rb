class Home < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :images, dependent: :destroy

  belongs_to :hunt, required: true
  belongs_to :creator_user, class_name: 'User', required: true

  validates :title, presence: true
  validates :address_street, presence: true
  validates :price, presence: true
  validates :creator_user, presence: true

  default_scope { order(:id) }

  scope :enabled, -> { where(disabled: false) }
  scope :disabled, -> { where(disabled: true) }

  accepts_nested_attributes_for :images, reject_if: :mark_empty_images_for_destruction, allow_destroy: true

  def default_image
    images.first&.url || placeholder_image
  end

  def placeholder_image
    'https://homepicker.s3.eu-west-2.amazonaws.com/homepicker.svg'
  end

  def mark_empty_images_for_destruction(attributes)
    exists = attributes['id'].present?
    empty = attributes.except(:id).values.all?(&:blank?)
    attributes.merge!(_destroy: 1) if exists && empty # destroy empty images

    !exists && empty # reject empty attributes
  end
end
