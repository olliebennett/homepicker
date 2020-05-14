class HuntMember < ApplicationRecord
  has_one :creator_user, class_name: 'User', required: true
  has_one :hunt, required: true
end
