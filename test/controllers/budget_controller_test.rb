require 'test_helper'

class BudgetControllerTest < ActionController::TestCase
  def test_shows_error_if_budget_not_exist
    get :show, id: 'not-existing-id'

    assert_response :not_found
  end

  def test_shows_budget_name
    post :create, budget: { name: 'Test' }
    budget = Budget.find_by(name: 'Test')

    get :show, id: budget.id
    assert_response :ok
    assert_equal({ "budget" => { "name" => "Test" } }, json_response)
  end

  def test_create_does_not_create_budget_if_there_is_no_name
    post :create, budget: { name: '' }

    assert_response :unprocessable_entity
    assert_equal(expected_response_with_no_name, json_response)
  end

  def test_create_does_not_create_budget_with_less_than_3_letters
    post :create, budget: { name: 'fo' }

    assert_response :unprocessable_entity
    assert_equal(expected_response_with_short_name, json_response)
  end

  def test_creates_budget_successfully
    post :create, budget: { name: "Budżet Nowej Prawicy" }

    assert_response :created
    assert(Budget.find_by(name: "Budżet Nowej Prawicy").present?, "budget is not created")
  end

  private
  def json_response
    JSON.parse(@response.body)
  end

  def expected_response_with_short_name
    { "errors" => { "name" => ["is too short (minimum is 3 characters)"] } }
  end

  def expected_response_with_no_name
    { "errors" => { "name" => ["can't be blank", "is too short (minimum is 3 characters)"] } }
  end
end