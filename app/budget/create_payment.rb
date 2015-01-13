class CreatePayment
  BudgetNotExist = Class.new(StandardError)
  InvalidPaymentValue = Class.new(StandardError)
  NotAllowed = Class.new(StandardError)

  def call(value, budget_id, session_id)
    budget = find_budget(budget_id)
    authorize(session_id, budget_id)
    payment = create_payment(value)
    budget.payments << payment
    payment
  rescue ActiveRecord::RecordNotFound
    raise BudgetNotExist.new('budget not exist')
  rescue ActiveRecord::RecordInvalid
    raise InvalidPaymentValue.new('invalid payment value')
  end

  private
  def authorize(session_id, budget_id)
    Session.find_by(id: session_id).tap do |session|
      raise NotAllowed.new unless session.budget_ids.include?(Integer(budget_id))
    end
  end

  def find_budget(budget_id)
    Budget.find(budget_id)
  end

  def create_payment(value)
    Payment.create!(value: value)
  end

end