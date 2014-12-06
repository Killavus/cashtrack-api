class Purchase < ActiveRecord::Base
  belongs_to :shopping
  belongs_to :product
  belongs_to :price

end
