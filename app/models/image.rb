class Image < ApplicationRecord
  belongs_to :home

  default_scope { order(:id) }

  auto_strip_attributes :url, squish: true
end
