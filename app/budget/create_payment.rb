class CreatePayment
  BudgetNotExist = Class.new(StandardError)
  InvalidPaymentValue = Class.new(StandardError)

  def create(value, budget_id)
    payment = create_payment(value)
    find_budget(budget_id).payments << payment
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