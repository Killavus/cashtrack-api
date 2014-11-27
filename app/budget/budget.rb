class Budget < ActiveRecord::Base
  has_many :payments, dependent: :destroy
  has_many :shopping, dependent: :destroy

  belongs_to :session, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3 }
end
