require 'test_helper'

class AuthenticationControllerTest < ActionController::TestCase
  def test_whether_it_gives_a_token_for_valid_credentials
     build_user

     post :create, user: { email: @email, password: @password }
     token_key = json_response["token_key"]
     expires_at = DateTime.parse(json_response["expires_at"])

     assert_expiration_date_in_future(expires_at)

     request.headers['X-Authentication-Token'] = token_key
     get :index
     assert_equal(expected_user_response, json_response)

     request.headers['X-Authentication-Token'] = nil
     get :index
     assert_response :forbidden
  end

  private
  def assert_expiration_date_in_future(expires_at)
    assert expires_at.future?
  end

  def expected_user_response
    {
      "email" => @email,
      "id" => 1
    }
  end

  def build_user
    @email = "foo@bar.com"
    @password = SecureRandom.hex
    register_user = RegisterUser.new
    register_user.call(@email, @password)
  end
end