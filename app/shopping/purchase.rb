class Purchase < ActiveRecord::Base
  belongs_to :shopping
  has_one :product
  validates :price, presence: true
  validates :price, numericality: { only_integer: true, greater_than: 0 }

end
