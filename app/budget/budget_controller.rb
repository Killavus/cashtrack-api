class BudgetController < ApplicationController
  def show
    budget = Budget.find(params[:id])
    render json: { budget: budget.as_json(only: :name) }
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def create
    budget = open_budget.(budget_params[:name], current_session.id)
    render status: :created, json: { budget_id: budget.id }
  rescue OpenBudget::SessionNotFound
    head :not_found
  rescue OpenBudget::InvalidBudgetName
    head :unprocessable_entity
  end

  private
  def budget_params
    params.require(:budget).permit(:name)
  end

  def open_budget
    OpenBudget.new
  end
end
