require 'test_helper'

class ClosingBudgetTest < ActionController::TestCase

  def test_closed_budget
    close_budget.(budget.id)
    assert Budget.find(budget.id).closed?
  end

  def test_cant_close_budget_two_times
    close_budget.(budget.id)
    assert_raises(CloseBudget::AlreadyClosed) {close_budget.(budget.id)}
  end

  def test_it_raises_error_if_budget_not_found
    assert_raises(CloseBudget::NotFound) { close_budget.(-1) }
  end

  private
  def session
    @session ||= establish_session.()
  end

  def budget
    @budget ||= open_budget.('test_budget', session.id)
  end

  def authorization_adapter
    AuthorizationAdapter.new.use(SessionAuthorizationStrategy.new(session))
  end

  def establish_session
    EstablishSession.new
  end

  def open_budget
    OpenBudget.new
  end

  def close_budget
    CloseBudget.new(authorization_adapter)
  end
end