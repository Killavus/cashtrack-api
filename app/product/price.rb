class Price < ActiveRecord::Base
  belongs_to :product
  has_one :localization
  validates :value, presence: true
  validates :value, numericality: { only_integer: true, greater_than: 0 }
end