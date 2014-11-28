class Payment < ActiveRecord::Base
  belongs_to :budget
  validates :value, presence: true, numericality: { only_integer: true, greater_than: 0  }
end
