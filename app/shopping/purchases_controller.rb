class PurchasesController < ApplicationController
  def create
    create_purchase = CreatePurchase.new
    create_purchase.create(params[:price], params[:product_params], params[:localization_params], params[:shopping_id])
    head :created
  rescue CreatePurchase::ShoppingNotExist
    head :not_found
  rescue CreatePurchase::InvalidPriceError
    head :unprocessable_entity
  rescue CreatePurchase::InvalidLocalizationParams
    head :unprocessable_entity
  rescue CreatePurchase::InvalidProductParams
    head :unprocessable_entity
  end


  private

  def purchase_params
    params.require(:purchase).permit(:price, product_params: [:name, :bar_code], localization_params: [:longitude, :latitude])
  end
end