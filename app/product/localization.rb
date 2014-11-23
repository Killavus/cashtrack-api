class Localization < ActiveRecord::Base
  belongs_to :price
  validates :latitude, :longitude, presence: true
  validates :latitude, :longitude, numericality: {only_float: true}
end
