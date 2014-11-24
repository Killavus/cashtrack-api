require 'test_helper'

class AccessTokensTest < ActiveSupport::TestCase
  def setup
    @email           = 'bob@example.me'
    @password        = SecureRandom.hex
    @expiration_date = DateTime.now.advance(days: 7)
    @user            = build_user

    @prepare_access_token   = PrepareAccessToken.new
    @authenticate_via_token = AuthenticateViaToken.new
  end

  def test_user_authenticate_returns_token
    token = prepare_access_token.call(@email, @password)
    assert_equal @expiration_date.iso8601, token.expires_at.iso8601
    assert_equal authenticate_via_token.call(token.key), @user
  end

  def test_user_authenticated_twice_returns_the_same_token
    token = prepare_access_token.call(@email, @password)
    another_token = prepare_access_token.call(@email, @password)

    assert_equal token, another_token
  end

  def test_after_expiration_it_returns_new_token
    token = prepare_access_token.call(@email, @password)
    token_after_expiration = prepare_access_token.call(@email, @password, @expiration_date.advance(seconds: 3))

    assert_not_equal token, token_after_expiration
  end

  def test_prepare_token_raises_error_when_password_invalid
    assert_raises(PrepareAccessToken::AuthenticationFailed) { prepare_access_token.call(@email, 'invalid password') }
  end

  def test_authenticate_token_raises_error_when_token_invalid
    assert_raises(AuthenticateViaToken::TokenNotFound) { authenticate_via_token.call('invalid token key') }
  end

  def test_authenticate_token_raises_error_when_token_expired
    token = prepare_access_token.call(@email, @password)
    assert_raises(AuthenticateViaToken::TokenInvalid) { authenticate_via_token.call(token.key, @expiration_date.advance(days: 2)) }
  end

  private
  attr_reader :prepare_access_token, :authenticate_via_token

  def build_user
    User.create(email: @email, password: @password)
  end
end