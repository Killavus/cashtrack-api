require 'test_helper'

class AddingPaymentTest < ActionController::TestCase
  def setup
    @payment = payment(4, budget.id)
  end

  def test_create_purchase_should_create_payment_with_right_value
    assert(Budget.first.payments.length == 1, 'payment budget is invalid')
    assert(Payment.first.value == 4, 'created purchase has invalid value' )
  end

  def test_create_purchase_should_raises_error_if_invalid_value_given
    assert_raises(AddPayment::InvalidPaymentValue) { add_payment.(-2, budget.id)  }
  end

  def test_create_purchase_should_raises_error_if_no_value_given
    assert_raises(AddPayment::InvalidPaymentValue) { add_payment.(nil, budget.id) }
  end

  def test_create_purchase_should_raises_error_if_budget_not_exist
    assert_raises(AddPayment::BudgetNotFound) { add_payment.(4, -2) }
  end

  def test_create_purchase_should_raises_error_if_no_int_value_given
    assert_raises(AddPayment::InvalidPaymentValue) { add_payment.("invalid", budget.id) }
  end

  def test_create_purchase_should_be_not_allowed_for_budgets_not_within_sessions
    assert_raises(AddPayment::NotAllowed) { add_payment.(700, another_budget.id) }
  end

  def open_budget
    OpenBudget.new
  end

  def budget
    @budget ||= open_budget.("test", session.id)
  end

  def another_budget
    @another_budget ||= open_budget.("test 2", another_session.id)
  end

  def another_session
    @another_session ||= establish_session.()
  end

  def session
    @session ||= establish_session.()
  end

  def authorization_adapter
    AuthorizationAdapter.new.use(SessionAuthorizationStrategy.new(session))
  end

  def establish_session
    EstablishSession.new
  end

  def payment(value, budget_id)
    add_payment.(value, budget_id)
  end

  def add_payment
    AddPayment.new(authorization_adapter)
  end

  def open_budget
    OpenBudget.new
  end
end