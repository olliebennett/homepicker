class Image < ApplicationRecord
  belongs_to :home

  default_scope { order(:id) }
end
