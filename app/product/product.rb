class Product < ActiveRecord::Base
  has_many :prices, dependent: :destroy
  validates :name, presence: true

end
