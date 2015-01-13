require 'test_helper'

class CreateBudgetTest < ActionController::TestCase
  def setup
    prepare_creating_object.call("valid", session.id)
  end

  def test_create_budget_should_create_budget_with_right_name
    assert(Session.first.budgets.length == 1, 'budget session is invalid')
    assert(Session.first.budgets.first.name == "valid", 'created budget has invalid value')
  end

  def test_create_budget_should_raises_error_if_session_not_exist
    assert_raises(CreateBudget::SessionNotExist) { prepare_creating_object.call("valid", -2)}
  end

  def test_creat_budget_should_raises_error_if_name_is_too_short
    assert_raises(CreateBudget::InvalidBudgetName) {prepare_creating_object.call("aa", session.id)}
  end

  def test_creat_budget_should_raises_error_if_no_name_given
    assert_raises(CreateBudget::InvalidBudgetName) {prepare_creating_object.call(nil, session.id)}
  end

  def session
    session_establisher = EstablishSession.new
    session_establisher.()
  end

  def prepare_creating_object
    CreateBudget.new
  end
end