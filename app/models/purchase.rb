class Purchase < ActiveRecord::Base
  belongs_to :shopping
  validates :price, presence: true
  validates :price, numericality: { only_integer: true, greater_than: 0 }

end
