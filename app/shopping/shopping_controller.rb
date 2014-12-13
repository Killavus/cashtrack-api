class ShoppingController < ApplicationController
  def create
    shopping_creator = CreateShopping.new
    shopping_creator.create(params[:budget_id])
    head :created
  rescue CreateShopping::BudgetNotExist
    head :not_found
  end

  def destroy
    shopping = Shopping.find(params[:id])
    return head :unprocessable_entity if shopping.end_date.present?
    shopping.end_date = Date.today()
    shopping.save!
    head :ok
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end
end

