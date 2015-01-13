class FinishShopping
  NotFound = Class.new(StandardError)
  AlreadyFinished = Class.new(StandardError)
  NotAllowed = Class.new(StandardError)

  def initialize(authorization_adapter)
    @authorization_adapter = authorization_adapter
  end

  def call(shopping_id)
    Shopping.find(shopping_id).tap do |shopping|
      raise AlreadyFinished.new if shopping.finished?
      raise NotAllowed.new unless authorization_adapter.has_access_to_budget?(shopping.budget)

      shopping.end_date = Date.today
      shopping.save!
    end
  rescue ActiveRecord::RecordNotFound
    raise NotFound.new
  end

  private
  attr_reader :authorization_adapter
end