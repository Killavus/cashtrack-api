class PresentBudgetOverview

  def prepare_for_budgets(budgets)
    prepare_object
    budgets.each do |budget|
      budget_overview = {}
      budget_overview[:name] = budget.name
      budget_overview[:payments] = payments_list(budget)
      budget_overview[:shopping] = shopping_list(budget)
      @budget_overview.add_budget(budget_overview)
    end
    return @budget_overview
  end

  private
  def prepare_object
    @budget_overview = BudgetOverview.new
  end

  def payments_list(budget)
    payments_values = []
    budget.payments.each { |payment| payments_values << hash_for_payment(payment) }
    payments_values
  end

  def hash_for_payment(payment)
    {value: payment.value, date: payment.created_at}
  end

  def shopping_list(budget)
    shopping_list = []
    budget.shopping.each {|shopping| shopping_list << hash_for_shopping(shopping) }
    shopping_list
  end

  def hash_for_shopping(shopping)
    {start_date: shopping.start_date, end_date: shopping.end_date, products: products_for_shopping(shopping)}
  end

  def products_for_shopping(shopping)
    products_for_shopping = []
    shopping.purchases.each do |purchase|
      product_hash = hash_for_product(purchase.product)
      product_hash[:price] = purchase.price.value
      products_for_shopping << product_hash
    end
    products_for_shopping
  end

  def hash_for_product(product)
    {product_name: product.name, bar_code: product.bar_code, localization: localization_for_product(product)}
  end

  def localization_for_product(product)
    {latitude: product.prices.take.localization.latitude, longitude: product.prices.take.localization.longitude}
  end
end
