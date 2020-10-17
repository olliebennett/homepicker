# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :home

  default_scope { order(:id) }

  auto_strip_attributes :external_url, squish: true

  def full_url_fallback
    full_url || external_url
  end

  def thumb_url_fallback
    thumb_url || external_url
  end
end
