require 'test_helper'

class FinishingShoppingTest < ActiveSupport::TestCase
  def test_it_finishes_shopping_session
    finish_shopping.(shopping.id)
    assert Shopping.find(shopping.id).finished?
  end

  def test_it_cannot_finish_shopping_twice
    finish_shopping.(shopping.id)
    assert_raises(FinishShopping::AlreadyFinished) { finish_shopping.(shopping.id) }
  end

  def test_it_raises_an_error_if_shopping_not_found
    assert_raises(FinishShopping::NotFound) { finish_shopping.('not existing ID') }
  end

  private
  def session
    @session ||= establish_session.()
  end

  def budget
    @budget ||= open_budget.('Budget #1', session.id)
  end

  def shopping
    @shopping ||= start_shopping.(budget.id)
  end

  def authorization_adapter
    AuthorizationAdapter.new.use(SessionAuthorizationStrategy.new(session))
  end

  def finish_shopping
    FinishShopping.new(authorization_adapter)
  end

  def start_shopping
    StartShopping.new(authorization_adapter)
  end

  def open_budget
    OpenBudget.new
  end

  def establish_session
    EstablishSession.new
  end
end