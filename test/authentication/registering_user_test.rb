require 'test_helper'

class RegisteringUserTest < ActiveSupport::TestCase
  def setup
    @register_user = RegisterUser.new
  end

  def test_registers_user_correctly
    password = SecureRandom.hex
    register_user.('foo@bar.me', password).tap do |user|
      token = PrepareAccessToken.new.(user.email, password)

      assert_equal user, AuthenticateViaToken.new.(token.key)
    end
  end

  def test_cant_register_user_with_same_email
    register_user.('foo@bar.me', SecureRandom.hex)
    assert_raises(RegisterUser::AlreadyRegistered) { register_user.('foo@bar.me', SecureRandom.hex) }
  end

  def test_cant_register_user_with_too_short_password
    assert_raises(RegisterUser::ValidationFailed) do
      register_user.('foo@bar.me', 'ts')
    end
  end

  private
  attr_reader :register_user
end