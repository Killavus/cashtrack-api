class ShoppingController < ApplicationController
  def create
    shopping_creator = CreateShopping.new
    shopping_creator.create(params[:budget_id])
    head :created
  rescue CreateShopping::BudgetNotExist
    head :not_found
  end
end

