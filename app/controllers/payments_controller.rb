class PaymentsController < ApplicationController
  def create
    budget = Budget.find(params[:budget_id])
    budget.payments << Payment.create!(value: payment_params[:value])
    head :created
  rescue ActiveRecord::RecordNotFound
    head :not_found
  rescue ActiveRecord::RecordInvalid => exception
    render_validation_errors(exception)
  end

  private
  def payment_params
    params.require(:payment).permit(:value)
  end


end