class ShoppingController < ApplicationController
  def create
    shopping_creator = CreateShopping.new(authorization_adapter)
    shopping_creator.call(params[:budget_id])
    head :created
  rescue CreateShopping::BudgetNotExist
    head :not_found
  rescue CreateShopping::NotAllowed
    head :forbidden
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

