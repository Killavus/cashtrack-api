require 'test_helper'

class CreatePurchasesTest < ActionController::TestCase
  def setup
    @payment = payment(4, budget.id)
  end

  def test_create_purchase_should_create_payment_with_right_value
    assert(Budget.first.payments.length == 1, 'payment budget is invalid')
    assert(Payment.first.value == 4, 'created purchase has invalid value' )
  end

  def test_create_purchase_should_raises_error_if_invalid_value_given
    assert_raises(CreatePayment::InvalidPaymentValue) { prepare_creating_object.call(-2, budget.id, authorization_adapter)  }
  end

  def test_create_purchase_should_raises_error_if_no_value_given
    assert_raises(CreatePayment::InvalidPaymentValue) { prepare_creating_object.call(nil, budget.id, authorization_adapter) }
  end

  def test_create_purchase_should_raises_error_if_budget_not_exist
    assert_raises(CreatePayment::BudgetNotExist) { prepare_creating_object.call(4, -2, authorization_adapter)}
  end

  def test_create_purchase_should_raises_error_if_no_int_value_given
    assert_raises(CreatePayment::InvalidPaymentValue) { prepare_creating_object.call("invalid", budget.id, authorization_adapter) }
  end

  def test_create_purchase_should_be_not_allowed_for_budgets_not_within_sessions
    assert_raises(CreatePayment::NotAllowed) { prepare_creating_object.call(700, another_budget.id, authorization_adapter) }
  end

  def create_budget
    CreateBudget.new
  end

  def budget
    @budget ||= create_budget.("test", session.id)
  end

  def another_budget
    @another_budget ||= create_budget.("test 2", another_session.id)
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
    prepare_creating_object.(value, budget_id, authorization_adapter)
  end

  def prepare_creating_object
    CreatePayment.new
  end
end