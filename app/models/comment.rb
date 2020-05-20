class Comment < ApplicationRecord
  belongs_to :home, counter_cache: true
  belongs_to :user

  validates :text, presence: true

  default_scope { order(:id) }

  auto_strip_attributes :text, squish: true

  def formatted_date
    created_at.strftime('%e %b @ %H:%M').squish
  end
end
