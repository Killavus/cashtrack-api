class CreatePurchase
  InvalidProductParams = Class.new(StandardError)
  InvalidLocalizationParams = Class.new(StandardError)
  InvalidPriceError = Class.new(StandardError)
  ShoppingNotExist = Class.new(StandardError)

  def create(price, product_params, localization_params, shopping_id)
    shopping = Shopping.find(shopping_id)
    ActiveRecord::Base.transaction do
      create_purchase
      @purchase.product = create_product(product_params)
      create_localization(localization_params)
      @product.prices << create_price(price)
      @price.localization = @localization
      @purchase.price = @price
      @localization.price = @price
      shopping.purchases << @purchase
      @purchase
    end
  rescue ActiveRecord::RecordNotFound
    raise ShoppingNotExist.new('shopping not exist')
  end

  private
  def create_price(price)
    @price = Price.create!(value: price)
  rescue ActiveRecord::RecordInvalid
    raise InvalidPriceError.new('invalid price value')
  end

  def create_localization(localization_params)
    @localization = Localization.create!(longitude: localization_params[:longitude], latitude: localization_params[:latitude])
  rescue ActiveRecord::RecordInvalid
    raise InvalidLocalizationParams.new('invalid localization attributes')
  end

  def create_product(product_params)
    if find_product(product_params)
      puts find_product(product_params).bar_code
      puts Product.find_by(bar_code: product_params[:bar_code])
      return @product = find_product(product_params)
    end
    @product = Product.create!(name: product_params[:name], bar_code: product_params[:bar_code])
  rescue ActiveRecord::RecordInvalid
    raise InvalidProductParams.new('invalid product params')
  end

  def create_purchase
    @purchase = Purchase.create!()
  end

  def find_product(product_params)
    @product ||= Product.find_by(bar_code: product_params[:bar_code])
  end
end