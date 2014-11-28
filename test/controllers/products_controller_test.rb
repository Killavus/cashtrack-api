require 'test_helper'

class ProductsControllerTest < ActionController::TestCase

  def test_create_product_must_have_right_name
    create_product("test","456461")

    assert_response :created
    assert(purchase.product != nil, "product is not created")
    assert(purchase.product.name == "test", "product has invalid value")
  end

  def test_create_product_must_have_right_bar_code
    create_product("valid", "123456789")

    assert_response :created
    assert(purchase.product != nil, "product is not created")
    assert(purchase.product.bar_code == "123456789", "product has invalid bar code")
  end

  def test_create_does_not_create_product_without_name
    create_product('', "545451")

    assert_response :unprocessable_entity
    assert_equal(expected_response_without_name, json_response)
  end

  def test_create_does_not_create_product_without_bar_code
    create_product('valid', '')

    assert_response :unprocessable_entity
    assert_equal(expected_response_without_bar_code, json_response)
  end

  def test_create_must_have_payments
    post :create, purchase_id: "invalid", product: { name: "test", bar_code: "12851854"}

    assert_response :not_found
  end

  def test_creates_product_successfully
    create_product("kiełbasa", "5546463546")

    assert_response :created
    assert(Product.find_by(name: "kiełbasa").present?, "Product is not created")
  end

  private
  def create_product(name_value, bar_code_value)
    post :create, purchase_id: purchase, product: {name: name_value, bar_code: bar_code_value }
  end

  def purchase()
    @purchase ||= Purchase.create!(shopping_id: shopping, price: 99)
  end

  def shopping
    @shopping ||= Shopping.create!(budget_id: budget.id)
  end

  def budget
    @budget ||= Budget.create!(name: "test", session_id: session)
  end

  def session
    establish_session = EstablishSession.new
    establish_session.()
  end

  def expected_response_without_name
    {"errors" => {"name" => ["can't be blank"] } }
  end

  def expected_response_without_bar_code
    {"errors" => {"bar_code" => ["can't be blank"] } }
  end

end