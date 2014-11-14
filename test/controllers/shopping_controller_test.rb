require 'test_helper'

class ShoppingControllerTest < ActionController::TestCase
  def test_create_must_have_budget
    post :create, budget_id: "niepoprawny"
    assert_response :not_found
  end
  def test_create_must_have_right_start_date
    create_shopping
    assert_response :created
    assert(budget.shopping.count == 1, "shopping_is_not_created")
    assert(budget.shopping.first.start_date == Date.today, "shopping_start_date_is_invalid")
  end



  private

  def create_shopping
    post :create, budget_id: budget.id
  end

  def budget
    @budget ||= Budget.create!(name: "Test")
  end

end