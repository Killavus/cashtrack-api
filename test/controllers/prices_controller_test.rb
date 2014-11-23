require 'test_helper'

class PricesControllerTest < ActionController::TestCase

  def test_create_price_must_have_right_value
    create_price(76)
    assert_response :created
    assert(product.prices.count == 1, "price is not created")
    assert(product.prices.take.value == 76, "price has invalid value" )
  end

  def test_create_cant_create_price_without_value
    create_price(nil)
    assert_response :unprocessable_entity
    assert_equal(expected_response_without_value, json_response)
  end

  def test_create_cant_create_price_with_no_int_value
    create_price("invalid")
    assert_response :unprocessable_entity
    assert_equal(expected_response_with_no_int_value, json_response)
  end

  def test_create_cant_create_with_negative_value
    create_price(-4)
    assert_response :unprocessable_entity
    assert_equal(expected_response_with_negative_value, json_response)
  end

  def test_create_must_have_product
    post :create, product_id: "invalid", price: {value: 89}
    assert_response :not_found

  end



  private

  def json_response
    JSON.parse(@response.body)
  end

  def create_price(price_value)
    post :create, product_id: product, price: {value: price_value }
  end

  def product
    @product ||= Product.create!(purchase_id: purchase, name: "test")

  end

  def purchase
    @purchase ||= Purchase.create!(shopping_id: shopping, price: 99)
  end

  def shopping
    @shopping ||= Shopping.create!(budget_id: budget.id)
  end

  def budget
    @budget ||= Budget.create!(name: "Test")
  end

  def expected_response_without_value
    { "errors" => {"value" => ["can't be blank", "is not a number" ] } }
  end

  def expected_response_with_no_int_value
    { "errors" => {"value" => ["is not a number"] } }
  end

  def expected_response_with_negative_value
    { "errors" => {"value" => ["must be greater than 0"] } }
  end

end

