class PaymentsController < ApplicationController
  def create
    payment_creator = CreatePayment.new(authorization_adapter)
    payment = payment_creator.(payment_params[:value], params[:budget_id])
    render status: :created, json: { payment_id: payment.id }
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