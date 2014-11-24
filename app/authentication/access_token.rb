class AccessToken < ActiveRecord::Base
  validates :key, presence: true
  validates :expires_at, presence: true
  validate :expiration_cannot_be_in_the_past, on: :create

  belongs_to :user, dependent: :destroy

  def self.find_current(user, now)
    preload(:user).where('expires_at > ?', now).find_by(user: user)
  end

  def expiration_cannot_be_in_the_past
    errors.add(:expires_at, 'must be in the future') unless expires_at.future?
  end

  def fresh?(now = DateTime.now)
    expires_at > now
  end
end