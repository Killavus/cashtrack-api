class PaymentsController < ApplicationController
  def create
    payment_creator = CreatePayment.new
    payment_creator.(payment_params[:value], params[:budget_id], current_session.id)
    head :created
  rescue CreatePayment::BudgetNotExist
    head :unprocessable_entity
  rescue CreatePayment::InvalidPaymentValue
    head :unprocessable_entity
  rescue CreatePayment::NotAllowed
    head :forbidden
  end

  private
  def payment_params
    params.require(:payment).permit(:value)
  end
end