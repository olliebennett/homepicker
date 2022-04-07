# frozen_string_literal: true

class Home < ApplicationRecord
  include Hashid::Rails

  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :images, dependent: :destroy

  belongs_to :hunt, optional: false
  belongs_to :creator_user, class_name: 'User', optional: false

  validates :title, presence: true
  validates :address_street, presence: true
  validates :price, presence: true

  default_scope { order(:id) }

  has_paper_trail only: [:price]

  auto_strip_attributes :address_street, squish: true
  auto_strip_attributes :address_locality, squish: true
  auto_strip_attributes :address_region, squish: true
  auto_strip_attributes :agent_url, squish: true
  auto_strip_attributes :postcode, squish: true
  auto_strip_attributes :rightmove_url, squish: true
  auto_strip_attributes :title, squish: true
  auto_strip_attributes :zoopla_url, squish: true
  auto_strip_attributes :description

  accepts_nested_attributes_for :images, reject_if: :mark_empty_images_for_destruction, allow_destroy: true

  def default_thumb
    images.first&.thumb_url_fallback || placeholder_image
  end

  def placeholder_image
    'https://homepicker.s3.eu-west-2.amazonaws.com/homepicker.svg'
  end

  def average_rating
    return nil if ratings.none?

    scores = ratings.map(&:score)

    (scores.sum * 10.0 / scores.count).round / 10.0
  end

  def mark_empty_images_for_destruction(attributes)
    exists = attributes['id'].present?
    empty = attributes.except(:id).values.all?(&:blank?)
    attributes[:_destroy] = 1 if exists && empty # destroy empty images

    !exists && empty # reject empty attributes
  end

  def price_display
    return 'UNKNOWN PRICE' if price.zero?

    # Assume monthly rental amount if < 10k
    if price > 10_000
      "£#{price / 1000}k"
    else
      "£#{price} pcm"
    end
  end

  def rightmove_search_link
    return nil if postcode.blank?

    "https://www.rightmove.co.uk/property-for-sale/search.html?searchLocation=#{postcode}&includeSSTC=true"
  end

  def zoopla_search_link
    return nil if postcode.blank?

    "https://www.zoopla.co.uk/search/?q=#{postcode}&include_sold=true&section=for-sale"
  end
end
