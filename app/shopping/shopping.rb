class Shopping < ActiveRecord::Base
  belongs_to :budget
  has_many :purchases, dependent: :destroy
end
