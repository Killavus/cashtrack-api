class Price < ActiveRecord::Base
  belongs_to :product
  validates :value, presence: true
  validates :value, numericality: { only_integer: true, greater_than: 0 }
end