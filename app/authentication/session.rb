class Session < ActiveRecord::Base
  belongs_to :user
  has_many :budgets

  def linked?
    user.present?
  end
end