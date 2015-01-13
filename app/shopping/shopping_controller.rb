class ShoppingController < ApplicationController
  def create
    start_shopping.(params[:budget_id])
    head :created
  rescue StartShopping::BudgetNotExist
    head :not_found
  rescue StartShopping::NotAllowed
    head :forbidden
  end

  def destroy
    finish_shopping.(params[:id])
    head :ok
  rescue FinishShopping::NotFound
    head :not_found
  rescue FinishShopping::NotAllowed
    head :forbidden
  rescue FinishShopping::AlreadyFinished
    head :unprocessable_entity
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private
  def start_shopping
    StartShopping.new(authorization_adapter)
  end

  def finish_shopping
    FinishShopping.new(authorization_adapter)
  end
end

