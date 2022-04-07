# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments, dependent: :destroy
  has_many :hunt_memberships, dependent: :destroy
  has_many :hunts, through: :hunt_memberships
  has_many :ratings, dependent: :destroy

  default_scope { order(:id) }

  def display_name
    email.scan(/.+@/).last[0...-1]
  end

  def gravatar_url(size = 100)
    "https://www.gravatar.com/avatar/#{md5_email}?s=#{size}&d=retro"
  end

  def md5_email
    Digest::MD5.hexdigest(email)
  end

  def hunt_member?(hunt)
    hunt_memberships.exists?(hunt:)
  end
end
