class Comment < ApplicationRecord
  belongs_to :home
  belongs_to :user

  validates :text, presence: true

  default_scope { order(:id) }

  def formatted_date
    created_at.strftime('%e %b @ %H:%M').squish
  end
end
