class PurchasesController < ApplicationController
  def create
    shopping = Shopping.find(params[:shopping_id])
    purchase = Purchase.create!(price: purchase_params[:price])
    unless product_params.present?
      head :forbidden
      return
    end
    purchase.product = create_product(purchase)
    shopping.purchases << purchase

    head :created
  rescue ActiveRecord::RecordNotFound
    head :not_found
  rescue ActiveRecord::RecordInvalid => exception
    render_validation_errors(exception)
  end


  private

  def find_product
    @product ||= Product.find_by(product_params[:bar_code])
  end

  def create_product(purchase_id)
    if find_product
      return find_product
    end
    Product.create!(purchase_id: purchase_id, name: product_params[:name], bar_code: product_params[:bar_code])
  end

  def product_params
    @product_params ||= purchase_params[:product_params]
  end

  def purchase_params
    params.require(:purchase).permit(:price, product_params: [:name, :bar_code])
  end
end