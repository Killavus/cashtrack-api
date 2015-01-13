class PaymentsController < ApplicationController
  def create
    payment = add_payment.(payment_params[:value], params[:budget_id])
    render status: :created, json: { payment_id: payment.id }
  rescue AddPayment::BudgetNotExist
    head :unprocessable_entity
  rescue AddPayment::InvalidPaymentValue
    head :unprocessable_entity
  rescue AddPayment::NotAllowed
    head :forbidden
  end

  private
  def add_payment
    AddPayment.new(authorization_adapter)
  end

  def payment_params
    params.require(:payment).permit(:value)
  end
end