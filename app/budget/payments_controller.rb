class PaymentsController < ApplicationController
  def create
    payment_creator = CreatePayment.new
    payment_creator.create(payment_params[:value], payment_params[:budget_id])
    head :created
  rescue CreatePayment::BudgetNotExist
    head :unprocessable_entity
  rescue CreatePayment::InvalidPaymentValue
    head :unprocessable_entity
  end
  private
  def payment_params
    params.require(:payment).permit(:value)
  end
end