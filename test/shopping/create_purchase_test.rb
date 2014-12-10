require 'test_helper'

class CreatePurchaseTest < ActionController::TestCase

  def setup
    @create_purchase = prepare_create_purchase_object
    @purchase = @create_purchase.create(10,{name: "valid", bar_code: "12345"}, {latitude: 34.2, longitude: 24.4}, shopping.id)
  end

  def test_object_should_create_purchase_price_product_and_localization
    purchase = @shopping.purchases.first
    assert(@shopping.purchases.length == 1, "purchase is not created")
    assert(purchase.price.present?, "price is not created")
    assert(purchase.product.present?, "product is not created")
    assert(purchase.price.localization.present?, "localization is not created")
    assert(purchase.product.prices.length == 1, "price for product is not created")
  end

  def test_object_should_create_purchase_product_price_and_localization_with_rigth_value
    purchase = @shopping.purchases.first
    assert(purchase.price.value == 10, "price has invalid value")
    assert(purchase.product.name == "valid", "product has invalid value")
    assert(purchase.product.bar_code == "12345", "product has invalid bar code")
    assert(purchase.price.localization.longitude == 24.4, "localization has invalid attribute")
    assert(purchase.price.localization.latitude == 34.2, "localization has invalid attribute")
  end

  def test_product_price_and_purchase_price_should_be_the_same
    assert(@shopping.purchases.take.price.id == @shopping.purchases.take.product.prices.take.id, "product price and purchase price are not the same")
  end

  def test_object_should_raises_error_if_no_product_params_given
    assert_raises(CreatePurchase::InvalidProductParams) { prepare_create_purchase_object.create(10, {}, {longitude: 22, latitude: 32}, @shopping.id) }
  end

  def test_object_should_raises_error_if_no_localization_params_given
    assert_raises(CreatePurchase::InvalidLocalizationParams) { prepare_create_purchase_object.create(10, {name: "valid", bar_code: "123"}, {}, @shopping.id) }
  end

  def test_object_should_raises_error_if_no_price_given
    assert_raises(CreatePurchase::InvalidPriceError) { prepare_create_purchase_object.create(nil, {name: "valid", bar_code: "123"}, {longitude: 22, latitude: 32}, @shopping.id) }
  end

  def test_object_should_raises_error_if_Shopping_not_exist
    assert_raises(CreatePurchase::ShoppingNotExist) { prepare_create_purchase_object.create(10, {name: "valid", bar_code: "123"}, {longitude: 22, latitude: 32}, -2) }
  end

  def test_object_should_raises_error_if_invalid_products_params_given
    assert_raises(CreatePurchase::InvalidProductParams) { prepare_create_purchase_object.create(10, {}, {longitude: 22, latitude: 32}, @shopping.id) }
  end

  def test_object_should_raises_error_if_invalid_localization_params_given
    assert_raises(CreatePurchase::InvalidLocalizationParams) { prepare_create_purchase_object.create(10, {name: "valid", bar_code: "123"}, {}, @shopping.id) }
  end

  def test_object_should_raises_error_if_invalid_price_given
    assert_raises(CreatePurchase::InvalidPriceError) { prepare_create_purchase_object.create(nil, {name: "valid", bar_code: "123"}, {longitude: 22, latitude: 32}, @shopping.id) }
  end

  private

  def budget
    @budget ||= Budget.create!(name: "test", session_id: session)
  end

  def session
    establish_session = EstablishSession.new
    establish_session.()
  end

  def shopping
    @shopping ||= Shopping.create! budget_id: budget.id
  end

  def prepare_create_purchase_object
    CreatePurchase.new
  end
end