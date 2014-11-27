require 'test_helper'

class MaintainingSessionTest < ActiveSupport::TestCase
  def setup
    @establish_session      = EstablishSession.new
    @link_session_with_user = LinkSessionWithUser.new

    build_user
  end

  def test_established_session_contains_secret_and_is_not_linked_with_user
    assert session.secret.present?, "secret key is not set within session"
    assert (not session.linked?), "session is linked (it shouldn't be)"
  end

  def test_linking_raises_error_if_session_not_found
    assert_raises(LinkSessionWithUser::SessionNotFound) { link_session_with_user.('no session', 'secret', user.id) }
  end

  def test_linking_raises_error_if_user_not_found
    assert_raises(LinkSessionWithUser::UserNotFound) { link_session_with_user.(session.id, session.secret, 'no user') }
  end

  def test_established_session_can_be_linked_with_user
    link_session_with_user.(session.id, session.secret, user.id)
    assert_includes(user.sessions, session, "session is not contained within user sessions")
  end

  def test_linking_session_requires_valid_secret
    assert_raises(LinkSessionWithUser::InvalidSecret) { link_session_with_user.(session.id, 'invalid secret', user.id) }
  end

  def test_session_already_linked_cannot_be_linked_again
    link_session_with_user.(session.id, session.secret, user.id)
    assert_raises(LinkSessionWithUser::AlreadyLinked) { link_session_with_user.(session.id, session.secret, user.id) }
  end

  private
  def session
    @session ||= establish_session.()
  end

  def build_user
    password = SecureRandom.hex
    register_user = RegisterUser.new
    register_user.("bob@example.com", password)

    prepare_access_token = PrepareAccessToken.new
    @token = prepare_access_token.("bob@example.com", password)
  end

  def user
    authenticate_via_token = AuthenticateViaToken.new
    authenticate_via_token.(@token.key)
  end

  attr_reader :establish_session, :link_session_with_user
end