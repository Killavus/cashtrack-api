require 'test_helper'

class AuthorizationStrategiesTest < ActiveSupport::TestCase
  def test_raises_an_error_if_no_strategy_used
    session = establish_session.()
    budget = create_budget.('Budget', session.id)
    adapter = AuthorizationAdapter.new

    assert_raises(AuthorizationAdapter::StrategyRequired) { adapter.has_access_to_budget?(budget) }
  end

  def test_user_be_authorized_to_change_budgets_from_all_his_sessions
    user = register_user.('foo@example.com', SecureRandom.hex)
    session_1 = establish_session.()
    session_2 = establish_session.()
    session_3 = establish_session.()

    budget_1 = create_budget.('Budget #1', session_1.id)
    budget_2 = create_budget.('Budget #2', session_2.id)
    budget_3 = create_budget.('Budget #3', session_3.id)

    link_session_with_user.(session_1.id, session_1.secret, user.id)
    link_session_with_user.(session_2.id, session_2.secret, user.id)

    user.reload

    strategy = user_authorization_strategy(user)
    adapter = authorization_adapter.use(strategy)

    assert adapter.has_access_to_budget?(budget_1), 'user does not have an access to budget 1'
    assert adapter.has_access_to_budget?(budget_2), 'user does not have an access to budget 2'
    assert_not adapter.has_access_to_budget?(budget_3), 'user has an invalid access to budget 3'
  end

  def test_session_be_authorized_only_to_belonging_budgets
    session_1 = establish_session.()
    session_2 = establish_session.()

    budget_1 = create_budget.('Budget #1', session_1.id)
    budget_2 = create_budget.('Budget #2', session_2.id)

    session_1.reload

    strategy = session_authorization_strategy(session_1)
    adapter = authorization_adapter.use(strategy)

    assert adapter.has_access_to_budget?(budget_1), 'session does not have an access to budget 1'
    assert_not adapter.has_access_to_budget?(budget_2), 'session has an invalid access to budget 2'
  end

  private
  def authorization_adapter
    AuthorizationAdapter.new
  end

  def user_authorization_strategy(user)
    UserAuthorizationStrategy.new(user)
  end

  def session_authorization_strategy(session)
    SessionAuthorizationStrategy.new(session)
  end

  def register_user
    RegisterUser.new
  end

  def establish_session
    EstablishSession.new
  end

  def link_session_with_user
    LinkSessionWithUser.new
  end

  def create_budget
    CreateBudget.new
  end
end