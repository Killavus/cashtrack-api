require 'test_helper'

class LocalizationControllerTest < ActionController::TestCase
  def test_create_add_localization_to_product_with_right_coordiantes

    create_localization(33.4,22.3)
    assert_response :created
    assert(price.localization != nil, "localization is not created" )
    assert(price.localization.longitude == 22.3, "localization longitude has invalid value")
    assert(price.localization.latitude == 33.4, "localization latitude has invalid value")
  end

  def test_create_cant_create_with_invalid_coordinates
    create_localization("a","b")
    assert_response :unprocessable_entity
    assert_equal(expected_response_with_invalid_coordinates, json_response)
  end

  def test_create_cant_create_without_coordinates
    create_localization(nil,nil)
    assert_response :unprocessable_entity
    assert_equal(expected_response_without_coordiantes, json_response)
  end

  def test_create_localization_must_have_price
    post :create, price_id: "invalid", localization: {latitude: 33.5, longitude: 12.54}
    assert_response :not_found
  end



  private
  def create_localization(latitude_value, longitude_value)
    post :create, price_id: price, localization: {longitude: longitude_value, latitude: latitude_value }
  end

  def price
    @price ||= Price.create!(product_id: product, value: 99)
  end

  def product
    @product ||= Product.create!(purchase_id: purchase, name: "test",name: "valid", bar_code: "654654")

  end

  def purchase
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

  def expected_response_without_coordiantes
    { "errors" => {"latitude"=>["can't be blank", "is not a number"], "longitude"=>["can't be blank", "is not a number"]} }
  end

  def expected_response_with_invalid_coordinates
    { "errors" => {"latitude"=>["is not a number"], "longitude"=>["is not a number"]} }
  end
end