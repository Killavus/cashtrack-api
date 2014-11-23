class ShoppingController < ApplicationController
  def create
    budget = Budget.find(params[:budget_id])
    shopping = Shopping.create!()
    shopping.start_date = Date.today
    budget.shopping << shopping

    head :created
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

end

