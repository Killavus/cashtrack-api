class LocalizationController < ApplicationController
  def create
    price = Price.find(params[:price_id])
    price.localization = Localization.create!(longitude: localization_params[:longitude], latitude: localization_params[:latitude])
    head :created
  rescue ActiveRecord::RecordNotFound
    head :not_found
  rescue ActiveRecord::RecordInvalid => exception
    render_validation_errors(exception)
  end

  private

  def localization_params
    params.require(:localization).permit(:latitude,:longitude)
  end
end