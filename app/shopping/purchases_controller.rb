class PurchasesController < ApplicationController
  def create
    create_purchase = CreatePurchase.new
    create_purchase.create(purchase_params[:price], purchase_params[:product_params], purchase_params[:localization_params], params[:shopping_id])
    head :created
  rescue CreatePurchase::ShoppingNotExist
    head :not_found
  rescue CreatePurchase::InvalidPriceError
    head :unprocessable_entity
  rescue CreatePurchase::InvalidLocalizationParams
    head :unprocessable_entity
  rescue CreatePurchase::InvalidProductParams
    head :unprocessable_entity
  rescue CreatePurchase::ShoppingClosed
    head :unprocessable_entity
  end

  private
  def purchase_params
    params.require(:purchase).permit(:price, product_params: [:name, :bar_code], localization_params: [:longitude, :latitude])
  end
end