require 'test_helper'

class OpeningBudgetTest < ActionController::TestCase
  def setup
    open_budget.call("valid", session.id)
  end

  def test_opening_budget_opens_budget_with_right_name
    assert(Session.first.budgets.length == 1, 'budget session is invalid')
    assert(Session.first.budgets.first.name == "valid", 'created budget has invalid value')
  end

  def test_opening_budget_raises_error_if_session_not_exist
    assert_raises(OpenBudget::SessionNotFound) { open_budget.call("valid", -2)}
  end

  def test_opening_budget_raises_error_if_name_is_too_short
    assert_raises(OpenBudget::InvalidBudgetName) { open_budget.call("aa", session.id) }
  end

  def test_opening_budget_raises_error_if_no_name_given
    assert_raises(OpenBudget::InvalidBudgetName) { open_budget.call(nil, session.id) }
  end

  private
  def session
    @session ||= establish_session.()
  end

  def establish_session
    EstablishSession.new
  end

  def open_budget
    OpenBudget.new
  end
end