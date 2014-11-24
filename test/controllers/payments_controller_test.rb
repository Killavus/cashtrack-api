require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  def test_create_adds_money_to_budget
    create_payment(99)

    assert_response :created
    assert(budget.payments.count == 1, "payment is not created" )
    assert(budget.payments.first.value == 99, "payment has invalid value")
  end

  def test_create_cant_add_invalid_payment
    create_payment(-9)

    assert_response :unprocessable_entity
    assert_equal(expected_response_with_invalid_value, json_response)
  end

  def test_create_cant_create_empty_payment
    create_payment(nil)

    assert_response :unprocessable_entity
    assert_equal(expected_response_without_value, json_response)
  end

  def test_create_must_have_budget
    post :create, budget_id: "marcina matka", payment: { value: 99 }

    assert_response :not_found
  end

  private
  def budget
    @budget ||= Budget.create!(name: "Test")
  end

  def create_payment(value)
    post :create, budget_id: budget.id, payment: {value: value}
  end

  def expected_response_without_value
    { "errors" => { "value" => ["can't be blank", "is not a number"] } }
  end

  def expected_response_with_invalid_value
    { "errors" => { "value" => ["must be greater than 0"] } }
  end
end