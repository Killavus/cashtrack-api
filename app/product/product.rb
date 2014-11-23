class Product < ActiveRecord::Base
  has_many :prices, dependent: :destroy
  validates :name, :bar_code, presence: true

end
