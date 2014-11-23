class ProductsController < ApplicationController
  def create
    purchase = Purchase.find(params[:purchase_id])
    purchase.product = Product.create!(name: product_params[:name], bar_code: product_params[:bar_code])
    head :created
  rescue ActiveRecord::RecordNotFound
    head :not_found
  rescue ActiveRecord::RecordInvalid => exception
    render_validation_errors(exception)
  end

  private
  def product_params
    params.require(:product).permit(:name, :bar_code)
  end
end