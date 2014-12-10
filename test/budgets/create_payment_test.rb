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
    assert_raises(CreatePayment::InvalidPaymentValue) { prepare_creating_object.create(-2, @budget.id )  }
  end

  def test_create_purchase_should_raises_error_if_no_value_given
    assert_raises(CreatePayment::InvalidPaymentValue) { prepare_creating_object.create(nil, @budget.id ) }
  end

  def test_create_purchase_should_raises_error_if_budget_not_exist
    assert_raises(CreatePayment::BudgetNotExist) { prepare_creating_object.create(4, -2)}
  end

  def test_create_purchase_should_raises_error_if_no_int_value_given
    assert_raises(CreatePayment::InvalidPaymentValue) { prepare_creating_object.create("invalid", @budget.id ) }
  end



  def budget
    @budget ||= Budget.create!(name: "test", session_id: session)
  end

  def session
    establish_session = EstablishSession.new
    establish_session.()
  end

  def payment(value, budget_id)
    prepare_creating_object.create(value, budget_id)
  end

  def prepare_creating_object
    CreatePayment.new
  end
end