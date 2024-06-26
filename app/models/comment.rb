# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :home, counter_cache: true
  belongs_to :user

  validates :text, presence: true

  default_scope { order(:id) }

  auto_strip_attributes :text

  def formatted_date
    created_at.strftime('%e %b').squish
  end
end
