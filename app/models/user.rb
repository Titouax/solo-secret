require 'bcrypt'

class User < ApplicationRecord

  before_save { self.email = email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, :on => :create
  validates :password_confirmation, presence: true, :on => :create
end
