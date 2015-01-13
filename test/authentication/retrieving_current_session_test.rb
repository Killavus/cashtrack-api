require 'test_helper'

class RetrievingCurrentSessionTest < ActiveSupport::TestCase
  def retrieve_current_session
    RetrieveCurrentSession.new
  end

  def establish_session
    EstablishSession.new
  end

  def register_user
    RegisterUser.new
  end

  def link_session_with_user
    LinkSessionWithUser.new
  end

  def test_retrieving_session_happy_path
    session = establish_session.()
    current_session = retrieve_current_session.(session.id, session.secret)
    assert_equal session, current_session
  end

  def test_retrieving_session_bails_out_with_invalid_credentials
    session = establish_session.()
    assert_raises(RetrieveCurrentSession::SessionNotFound) { retrieve_current_session.('invalid id', 'invalid secret') }
    assert_raises(RetrieveCurrentSession::SessionNotFound) { retrieve_current_session.(session.id, 'invalid secret') }
    assert_raises(RetrieveCurrentSession::SessionNotFound) { retrieve_current_session.('invalid id', session.secret) }
  end

  def test_retrieving_current_session_fails_if_linked_to_user_already
    user = register_user.('foo@example.com', SecureRandom.uuid)
    session = establish_session.()

    link_session_with_user.(session.id, session.secret, user.id)
    assert_raises(RetrieveCurrentSession::LinkedToUser) { retrieve_current_session.(session.id, session.secret) }
  end
end