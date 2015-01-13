require 'test_helper'

class CreateShoppingTest < ActionController::TestCase
  def setup
    prepare_creating_object.call(budget.id)
  end

  def test_create_shopping_should_create_shopping_with_right_start_date
    assert(Budget.first.shopping.length == 1, 'shopping budget is invalid')
    assert(Shopping.first.start_date == Date.today, 'test_create_shopping_with_invalid_date')
  end

  def test_create_shopping_should_raises_error_if_budget_not_exist
    assert_raises(CreateShopping::BudgetNotExist) { prepare_creating_object.call(-2)}
  end

  def budget
    @budget ||= CreateBudget.new.("test", session.id)
  end

  def establish_session
    EstablishSession.new
  end

  def session
    @session ||= establish_session.()
  end

  def authorization_adapter
    AuthorizationAdapter.new.use(SessionAuthorizationStrategy.new(session))
  end

  def prepare_creating_object
    CreateShopping.new(authorization_adapter)
  end
end