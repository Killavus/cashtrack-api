class Budget < ActiveRecord::Base
  has_many :payments, dependent: :destroy
  validates :name, presence: true, length: { minimum: 3 }
end
