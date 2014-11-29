require 'test_helper'

class RetrieveBudgetsForSessionTest < ActionController::TestCase

  def setup
    @session_establisher = EstablishSession.new
    @retrieve_budget_for_session = RetrieveBudgetsForSession.new
  end

  def test_retrieve_budgets_raises_error_when_token_invalid
    test_session = @session_establisher.()
    assert_raises(RetrieveBudgetsForSession::InvalidSecret) { @retrieve_budget_for_session.(test_session.id, "invalid") }
  end

  def test_retrieve_budgets_raises_error_when_session_not_exist
    assert_raises(RetrieveBudgetsForSession::SessionNotFound) { @retrieve_budget_for_session.(-1, "invalid") }
  end

  def test_retrieve_budget_should_return_empty_list_when_no_bugets_found
    test_session = @session_establisher.()
    assert_equal @retrieve_budget_for_session.(test_session.id, test_session.secret), []
  end

  def test_retrieve_should_return_right_budgets
    test_session = @session_establisher.()
    test_budget = Budget.create!(name: "test", session_id: test_session.id)
    test_budget2 = Budget.create!(name: "test2", session_id: test_session.id)
    retrieved_budgets = @retrieve_budget_for_session.(test_session.id, test_session.secret)
    assert(retrieved_budgets[0].name == test_budget.name, "test_budget not exist in retrived budgets")
    assert(retrieved_budgets[1].name == test_budget2.name, "test_budget2 not exist in retrieved budgets")
  end

  def test_retrieve_should_return_right_numbers_of_budgets
    test_session = @session_establisher.()
    create_many_budget(10, test_session.id)
    retrieved_budgets = @retrieve_budget_for_session.(test_session.id, test_session.secret)

    assert(retrieved_budgets.length == 10, "function do not return all budgets")
  end

  private

  def create_many_budget(number, session_id)
    (1..number).each do
      Budget.create!(name: "test", session_id: session_id)
    end
  end
end