class PricesController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    product.prices << Price.create!(value: price_params[:value])
    head :created
  rescue ActiveRecord::RecordNotFound
    head :not_found
  rescue ActiveRecord::RecordInvalid => exception
    render_validation_errors(exception)
  end


  private

  def price_params
    params.require(:price).permit(:value)
  end
end