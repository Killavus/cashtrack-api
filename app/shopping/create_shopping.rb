class CreateShopping < ApplicationController
  BudgetNotExist = Class.new(StandardError)

  def create(budget_id)
    shopping = prepare_shopping
    shopping.start_date = Date.today
    find_budget(budget_id).shopping << shopping
    shopping

  rescue ActiveRecord::RecordNotFound
    raise BudgetNotExist.new('budget not exist' )
  end

  def find_budget(budget_id)
    Budget.find(budget_id)
  end

  def prepare_shopping
    Shopping.create!()
  end
end