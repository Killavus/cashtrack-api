require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase

  def test_create_cant_create_without_price
    create_purchase(nil, {name: "valid", bar_code: "5454555"})
    assert_response :unprocessable_entity
    assert_equal(expected_response_without_price, json_response)
  end

  def test_create_cant_create_with_no_int_price
    create_purchase("aa", {name: "valid", bar_code: "448645"})
    assert_response :unprocessable_entity
    assert_equal(expected_response_with_invalid_price_value, json_response)
  end

  def test_create_cant_create_with_invalid_price
    create_purchase(-9, {name: "valid", bar_code: "454545"})
    assert_response :unprocessable_entity
    assert_equal(expected_response_with_negative_price, json_response)
  end

  def test_create_must_have_rigth_price
    create_purchase(10, {name: "valid", bar_code: "5465464"})
    assert_response :created
    assert(shopping.purchases.count == 1, "purchase is not created" )
    assert(shopping.purchases.first.price == 10, "purchase has invalid value")
  end

  def test_create_must_have_shopping
    post :create, shopping_id: "invalid"
    assert_response :not_found
  end


  def test_create_cant_create_without_product_params
    create_purchase(45, nil)
    assert_response :forbidden
  end

  def test_create_purchase_must_create_right_product
    create_purchase(99, {name: "valid", bar_code: "456456456"})
    assert_response :created
    assert(shopping.purchases.first.product != nil, "product_is_not_created")
    assert(shopping.purchases.first.product.bar_code == "456456456", "product bar code is invalid")
    assert(shopping.purchases.first.product.name == "valid", "product name is invalid")
  end

  def test_create_purchase_should_find_product_by_bar_code
    product_to_test = Product.create(name: "pomidor", bar_code: "123456")
    create_purchase(99, {name: "pomidor", bar_code: "123456"})
    assert(shopping.purchases.first.product.id == product_to_test.id, "Purchase create other product with same bar code")
  end

  private
  def create_purchase(value, product_params)
    post :create, shopping_id: shopping.id, purchase: { price: value, product_params: product_params }
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