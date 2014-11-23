class BudgetController < ApplicationController
  def show
    budget = Budget.find(params[:id])
    render json: { budget: budget.as_json(only: :name) }
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def create
    Budget.create!(name: budget_params[:name])
    head :created
  rescue ActiveRecord::RecordInvalid => exc
    render_validation_errors(exc)
  end

  private
  def budget_params
    params.require(:budget).permit(:name)
  end
end
