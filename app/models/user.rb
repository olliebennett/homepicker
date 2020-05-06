class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments

  def gravatar_url(size=100)
    "https://www.gravatar.com/avatar/#{md5_email}?s=#{size}&d=retro"
  end

  def md5_email
    Digest::MD5.hexdigest(email)
  end
end
