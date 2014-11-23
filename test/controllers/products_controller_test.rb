require 'test_helper'

class ProductsControllerTest < ActionController::TestCase

  def test_create_product_must_have_right_name
    create_product("test")
    assert_response :created
    assert(purchase.product != nil, "product is not created")
    assert(purchase.product.name == "test", "product has invalid value")
  end

  def test_create_does_not_create_product_without_name
    create_product('')

    assert_response :unprocessable_entity
    assert_equal(expected_response_without_name, json_response)
  end

  def test_create_must_have_payments
    post :create, purchase_id: "invalid", product: { name: "test" }
    assert_response :not_found
  end

  def test_creates_product_successfully
    create_product("kiełbasa")

    assert_response :created
    assert(Product.find_by(name: "kiełbasa").present?, "Product is not created")
  end


  private

  def json_response
    JSON.parse(@response.body)
  end

  def create_product(name_value)
    post :create, purchase_id: purchase, product: {name: name_value }
  end

  def purchase()
    @purchase ||= Purchase.create!(shopping_id: shopping, price: 99)
  end

  def shopping
    @shopping ||= Shopping.create!(budget_id: budget.id)
  end

  def budget
    @budget ||= Budget.create!(name: "Test")
  end

  def expected_response_without_name
    {"errors" => {"name" => ["can't be blank"] } }
  end

end