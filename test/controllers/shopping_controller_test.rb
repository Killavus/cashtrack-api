require 'test_helper'

class ShoppingControllerTest < ActionController::TestCase
  def setup
    set_session_headers(session)
  end

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
    test_shopping = start_shopping.(budget.id)
    finish_shopping.(test_shopping.id)
    delete :destroy, id: test_shopping.id
    assert_response :unprocessable_entity
  end

  private
  def shopping
    @shopping = start_shopping.call(budget.id)
  end

  def budget
    budget_creator = OpenBudget.new
    @budget ||= budget_creator.call("valid", session.id)
  end

  def authorization_adapter
    AuthorizationAdapter.new.use(SessionAuthorizationStrategy.new(session))
  end

  def establish_session
    EstablishSession.new
  end

  def start_shopping
    StartShopping.new(authorization_adapter)
  end

  def finish_shopping
    FinishShopping.new(authorization_adapter)
  end

  def session
    @session ||= establish_session.()
  end

  def set_session_headers(session)
    request.headers['X-Session-Id'] = session.id
    request.headers['X-Session-Secret'] = session.secret
  end
end