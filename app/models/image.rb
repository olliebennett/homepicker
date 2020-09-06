class Image < ApplicationRecord
  belongs_to :home

  default_scope { order(:id) }

  auto_strip_attributes :external_url, squish: true

  def full_url
    # TODO: Rely on persisted URL, falling back to external
    external_url
  end

  def thumb_url
    # TODO: Rely on generated thumbnail URL, falling back to external
    external_url
  end
end
