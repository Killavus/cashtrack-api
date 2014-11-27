class User < ActiveRecord::Base
  validates :email, presence: true
  validates :password, length: { minimum: 3 }, on: :create

  has_many :sessions
  has_secure_password
end