require 'test_helper'

class ShoppingControllerTest < ActionController::TestCase

  def test_delete_should_close_shopping
    delete :destroy, id: shopping.id
    assert_response :ok
    assert(Shopping.first.end_date == Date.today(), "budget is open")
  end

  def test_delete_should_show_error_when_shopping_not_found
    delete :destroy, id: -2
    assert_response :not_found
  end

  def test_delete_should_show_error_when_shopping_already_closed
    test_shopping = Shopping.create!(start_date: Date.today(), end_date: Date.today())
    delete :destroy, id: test_shopping.id
    assert_response :unprocessable_entity
  end

  private
  def shopping
    shopping_creator = CreateShopping.new
    @shopping = shopping_creator.create(budget.id)
  end

  def budget
    budget_creator = CreateBudget.new
    @budget ||= budget_creator.create("valid", session.id)
  end

  def session
    session_establisher = EstablishSession.new
    session_establisher.()
  end
end