class ProductsController < ApplicationController
  def create
    purchase = Purchase.find(params[:purchase_id])
    purchase.product = Product.create!(name: product_params[:name])
    head :created
  rescue ActiveRecord::RecordNotFound
    head :not_found
  rescue ActiveRecord::RecordInvalid => exception
    render_validation_errors(exception)
  end

  private
  def product_params
    params.require(:product).permit(:name)
  end
end