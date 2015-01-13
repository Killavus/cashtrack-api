class CreateShopping < ApplicationController
  BudgetNotExist = Class.new(StandardError)
  NotAllowed = Class.new(StandardError)

  def initialize(authorization_adapter)
    @authorization_adapter = authorization_adapter
  end

  def call(budget_id)
    budget = find_budget(budget_id)
    raise NotAllowed.new unless authorization_adapter.has_access_to_budget?(budget)
    shopping = prepare_shopping
    shopping.start_date = Date.today
    budget.shopping << shopping
    shopping

  rescue ActiveRecord::RecordNotFound
    raise BudgetNotExist.new('budget not exist' )
  end

  def find_budget(budget_id)
    Budget.find(budget_id)
  end

  def prepare_shopping
    Shopping.create!
  end

  private
  attr_reader :authorization_adapter
end