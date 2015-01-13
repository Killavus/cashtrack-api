class User < ActiveRecord::Base
  SessionNotFound = Class.new(StandardError)

  validates :email, presence: true
  validates :password, length: { minimum: 3 }, on: :create

  has_many :sessions
  has_secure_password

  def current_session
    sessions.first!
  rescue ActiveRecord::ActiveRecordError
    raise SessionNotFound.new
  end
end