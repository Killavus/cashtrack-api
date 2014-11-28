require 'test_helper'

class BudgetControllerTest < ActionController::TestCase
  def setup
    @session = create_session
  end

  def test_shows_error_if_budget_not_exist
    get :show, id: 'not-existing-id'

    assert_response :not_found
  end

  def test_shows_budget_name
    create_budget 'Test'
    budget = Budget.find_by(name: 'Test')

    get :show, id: budget.id
    assert_response :ok
    assert_equal({ "budget" => { "name" => "Test" } }, json_response)
  end

  def test_create_does_not_create_budget_if_there_is_no_name
    create_budget ''
    assert_response :unprocessable_entity
    assert_equal(expected_response_with_no_name, json_response)
  end

  def test_create_does_not_create_budget_with_less_than_3_letters
    create_budget 'fo'

    assert_response :unprocessable_entity
    assert_equal(expected_response_with_short_name, json_response)
  end

  def test_creates_budget_successfully
    post :create, session_id: @session.id, budget: { name: "Budżet Nowej Prawicy" }

    assert_response :created
    assert(Budget.find_by(name: "Budżet Nowej Prawicy").present?, "budget is not created")
  end

  def test_must_have_session
    post :create, session_id: "invalid", budget: { name: "valid" }

    assert_response :not_found
  end

  private
  def create_budget(name_value)
    post :create, session_id: @session.id, budget: { name: name_value}
  end

  def create_session
    establish_session = EstablishSession.new
    establish_session.()
  end

  def expected_response_with_short_name
    { "errors" => { "name" => ["is too short (minimum is 3 characters)"] } }
  end

  def expected_response_with_no_name
    { "errors" => { "name" => ["can't be blank", "is too short (minimum is 3 characters)"] } }
  end
end
