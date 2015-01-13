class CreatePayment
  BudgetNotExist = Class.new(StandardError)
  InvalidPaymentValue = Class.new(StandardError)
  NotAllowed = Class.new(StandardError)

  def call(value, budget_id, authorization_adapter)
    budget = find_budget(budget_id)
    raise NotAllowed.new unless authorization_adapter.has_access_to_budget?(budget)
    payment = create_payment(value)
    budget.payments << payment
    payment
  rescue ActiveRecord::RecordNotFound
    raise BudgetNotExist.new('budget not exist')
  rescue ActiveRecord::RecordInvalid
    raise InvalidPaymentValue.new('invalid payment value')
  end

  private
  def find_budget(budget_id)
    Budget.find(budget_id)
  end

  def create_payment(value)
    Payment.create!(value: value)
  end

end