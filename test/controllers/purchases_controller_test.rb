require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase

  def test_create_cant_create_without_price
    create_purchase(nil)
    assert_response :unprocessable_entity
    assert_equal(expected_response_without_price, json_response)
  end

  def test_create_cant_create_with_no_int_price
    create_purchase("aa")
    assert_response :unprocessable_entity
    assert_equal(expected_response_with_invalid_price_value, json_response)
  end

  def test_create_cant_create_with_invalid_price
    create_purchase(-9)
    assert_response :unprocessable_entity
    assert_equal(expected_response_with_negative_price, json_response)
  end

  def test_create_must_have_rigth_price
    create_purchase(10)
    assert_response :created
    assert(shopping.purchases.count == 1, "purchase is not created" )
    assert(shopping.purchases.first.price == 10, "purchase has invalid value")
  end

  def test_create_must_have_shopping
    post :create, shopping_id: "invalid"
    assert_response :not_found
  end



  private

  def json_response
    JSON.parse(@response.body)
  end

  def create_purchase(value)
    post :create, shopping_id: shopping.id, purchase: { price: value }
  end

  def budget
    @budget ||= Budget.create!(name: "test")
  end
  def shopping

    @shopping ||= Shopping.create! budget_id: budget.id
  end

  def expected_response_with_invalid_price_value
    { "errors" => { "price" => ["is not a number"] } }
  end

  def expected_response_without_price
    { "errors" => { "price" => ["can't be blank", "is not a number"] } }
  end

  def expected_response_with_negative_price
    { "errors" => { "price" => ["must be greater than 0"] } }
  end



end