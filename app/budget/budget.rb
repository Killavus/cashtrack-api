class Budget < ActiveRecord::Base
  has_many :payments, dependent: :destroy
  has_many :shopping, dependent: :destroy
  has_one :budget_closed, dependent: :destroy
  belongs_to :session

  validates :name, presence: true, length: { minimum: 3 }

  def closed?
    budget_closed.present?
  end
end
