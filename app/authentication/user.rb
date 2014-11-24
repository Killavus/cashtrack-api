class User < ActiveRecord::Base
  validates :email, presence: true

  has_many :sessions
  has_secure_password
end