class PurchasesController < ApplicationController
  def create
    shopping = Shopping.find(params[:shopping_id])
    shopping.purchases << Purchase.create!(price: purchase_params[:price])
    head :created
  rescue ActiveRecord::RecordNotFound
    head :not_found
  rescue ActiveRecord::RecordInvalid => exception
    render_validation_errors(exception)
  end

  private

  def purchase_params
    params.require(:purchase).permit(:price)
  end
end