class Shopping < ActiveRecord::Base
  belongs_to :budget
  has_many :purchases, dependent: :destroy

  def finished?
    end_date.present?
  end
end
