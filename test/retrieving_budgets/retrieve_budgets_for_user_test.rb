require 'test_helper'

class RetrieveBudgetsForUserTest < ActionController::TestCase

  def setup
    @session_establisher = EstablishSession.new
    @retrieve_budget_for_user = RetrieveBudgetForUser.new
    @user = prepare_user
  end

  def test_retrieve_budgets_raises_error_when_session_not_exist
    register_user = RegisterUser.new
    test_user = register_user.("f@b.com", "valid")
    assert_raises(RetrieveBudgetForUser::SessionNotFound) { @retrieve_budget_for_user.(test_user) }
  end

  def test_retrieve_budget_should_return_empty_list_when_no_bugets_found
    test_session = create_session
    assert_equal @retrieve_budget_for_user.(@user), []
  end

  def test_retrieve_should_return_right_budgets
    test_session = create_session
    test_budget = Budget.create!(name: "test", session_id: test_session.id)
    test_budget2 = Budget.create!(name: "test2", session_id: test_session.id)
    retrieved_budgets = @retrieve_budget_for_user.(@user)

    assert(retrieved_budgets[0].name == test_budget.name, "test_budget not exist in retrived budgets")
    assert(retrieved_budgets[1].name == test_budget2.name, "test_budget2 not exist in retrieved budgets")
  end

  def test_retrieve_should_return_right_numbers_of_budgets
    test_session = create_session
    create_many_budget(10, test_session.id)
    retrieved_budgets = @retrieve_budget_for_user.(@user)

    assert(retrieved_budgets.length == 10, "function do not return all budgets")
  end

  def test_retrieve_should_return_budgets_from_all_sessions
    test_session = create_session
    create_many_budget(10, test_session.id)
    test_session = create_session
    create_many_budget(8, test_session.id)
    test_session = create_session
    create_many_budget(3, test_session.id)

    retrieved_budgets = @retrieve_budget_for_user.(@user)

    assert(retrieved_budgets.length == 21, "function do not return all budgets")
  end

  private

  def create_many_budget(number, session_id)
    (1..number).each do
      Budget.create!(name: "test", session_id: session_id)
    end
  end

  def prepare_user
    register_user = RegisterUser.new
    register_user.("foo@bar.com", "valid")
  end

  def create_session
    session = @session_establisher.()
    link_session_to_user(session)
    session
  end

  def link_session_to_user(session)
    link_session_to_user = LinkSessionWithUser.new
    link_session_to_user.(session.id, session.secret, @user.id)
  end
end