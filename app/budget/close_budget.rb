class CloseBudget
  NotFound = Class.new(StandardError)
  AlreadyClosed = Class.new(StandardError)
  NotAllowed = Class.new(StandardError)

  def initialize(authorization_adapter)
    @authorization_adapter = authorization_adapter
  end

  def call(budget_id)
    Budget.find(budget_id).tap do |budget|
      raise AlreadyClosed.new if budget.closed?
      raise NotAllowed.new unless @authorization_adapter.has_access_to_budget?(budget)

      budget_closed = BudgetClosed.new(budget_id: budget_id)
      budget_closed.save!
    end
  rescue ActiveRecord::RecordNotFound
    raise NotFound.new
  end
end