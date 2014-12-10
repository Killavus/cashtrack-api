class BudgetController < ApplicationController
  def show
    budget = Budget.find(params[:id])
    render json: { budget: budget.as_json(only: :name) }
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def create
    budget_creator = CreateBudget.new
    budget_creator.create(params[:name], params[:session_id])
    head :created

  rescue CreateBudget::SessionNotExist
    head :not_found
  rescue CreateBudget::InvalidBudgetName
    head :unprocessable_entity
  end


  private
  def budget_params
    params.require(:budget).permit(:name)
  end
end
