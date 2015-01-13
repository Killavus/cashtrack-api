class PurchasesController < ApplicationController
  def create
    make_purchase.(purchase_params[:price], purchase_params[:product_params], purchase_params[:localization_params], params[:shopping_id])
    head :created
  rescue MakePurchase::ShoppingNotFound
    head :not_found
  rescue MakePurchase::InvalidPriceError
    head :unprocessable_entity
  rescue MakePurchase::InvalidLocalizationParams
    head :unprocessable_entity
  rescue MakePurchase::InvalidProductParams
    head :unprocessable_entity
  rescue MakePurchase::ShoppingClosed
    head :unprocessable_entity
  end

  private
  def make_purchase
    MakePurchase.new
  end

  def purchase_params
    params.require(:purchase).permit(:price, product_params: [:name, :bar_code], localization_params: [:longitude, :latitude])
  end
end