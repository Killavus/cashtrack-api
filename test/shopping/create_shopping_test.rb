require 'test_helper'

class CreateShoppingTest < ActionController::TestCase
  def setup
    prepare_creating_object.create(budget.id)
  end

  def test_create_shopping_should_create_shopping_with_right_start_date
    assert(Budget.first.shopping.length == 1, 'shopping budget is invalid')
    assert(Shopping.first.start_date == Date.today, 'test_create_shopping_with_invalid_date')
  end

  def test_create_shopping_should_raises_error_if_budget_not_exist
    assert_raises(CreateShopping::BudgetNotExist) { prepare_creating_object.create(-2)}
  end

  def budget
    @budget ||= Budget.create!(name: "test", session_id: session)
  end

  def session
    establish_session = EstablishSession.new
    establish_session.()
  end

  def prepare_creating_object
    CreateShopping.new
  end
end