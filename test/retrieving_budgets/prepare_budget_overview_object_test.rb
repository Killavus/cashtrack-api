require 'test_helper'

class PrepareBudgetOverviewObjectTest < ActionController::TestCase
  def setup
    @prepare_budget_overview_object = PresentBudgetOverview.new

  end

  def test_budget_overview_should_return_empty_list_when_no_budgets_given
    budget_overview = @prepare_budget_overview_object.prepare_for_budgets([]).get_overview_list
    assert(budget_overview.empty?, "budget overview is not an empty list")
  end
# test case with complete data


  def test_budget_overview_should_return_rigth_budgets
    budget_overview = prepare_full_data_overview_object

    assert(budget_overview[0][:name] == "budget1" && budget_overview[1][:name] == "budget2", "budget overview return wrfull_data_overview_objectong budgets")
  end

  def test_budget_overview_should_return_rigth_products_values
    budget_overview = prepare_full_data_overview_object
    assert(valid_product_values?(budget_overview[0][:shopping][0][:products][0], 10, "111", [1,11]), "wrong product values")
    assert(valid_product_values?(budget_overview[0][:shopping][1][:products][0], 20, "222", [2,12]), "wrong product values")
    assert(valid_product_values?(budget_overview[0][:shopping][1][:products][1], 30, "333", [3,13]), "wrong product values")
    assert(valid_product_values?(budget_overview[1][:shopping][0][:products][0], 40, "444", [4,14]), "wrong product values")
    assert(valid_product_values?(budget_overview[1][:shopping][1][:products][0], 50, "555", [5,15]), "wrong product values")
    assert(valid_product_values?(budget_overview[1][:shopping][1][:products][1], 60, "666", [6,16]), "wrong product values")
    assert(valid_product_values?(budget_overview[1][:shopping][1][:products][2], 70, "777", [7,17]), "wrong product values")
  end

  def test_budget_overview_should_return_rigth_shoppings
    budget_overview = prepare_full_data_overview_object
    assert(budget_overview[0][:shopping][0][:start_date] == Date.today, "object return wrong shopping")
    assert(budget_overview[0][:shopping][1][:start_date] == Date.today, "object return wrong shopping")
    assert(budget_overview[1][:shopping][0][:start_date] == Date.today, "object return wrong shopping")
    assert(budget_overview[0][:shopping][1][:start_date] == Date.today, "object return wrong shopping")
  end

  def test_budget_overview_should_return_rigth_purchases
    budget_overview = prepare_full_data_overview_object

    assert(budget_overview[0][:payments][0][:value] == 100, "budget overview return wrong payments" )
    assert(budget_overview[0][:payments][1][:value] == 200, "budget overview return wrong payments" )
    assert(budget_overview[1][:payments][0][:value] == 300, "budget overview return wrong payments" )
  end

  def test_of_case_with_complete_data
    budget_overview = prepare_full_data_overview_object

    assert(budget_overview.length == 2, "budget overview return wrong number of budgets")
    assert(valid_number_of_payments?(budget_overview), "budget overview return wrong number of payment")
    assert(valid_number_of_shopping?(budget_overview), "budget overview return wrong number of shopping")
    assert(valid_number_of_products?(budget_overview), "budget overview return wrong number of products")
  end
# end test with complete data

  def valid_product_values?(product, price, bar_code, localization)
    product[:price] == price &&
    product[:bar_code] == bar_code &&
    product[:localization] == {latitude: localization[0], longitude: localization[1]}
  end
  private
  def valid_number_of_payments?(budget_list)
    budget_list[0][:payments].length == 2 && budget_list[1][:payments].length == 1
  end

  def valid_number_of_shopping?(budget_list)
    budget_list[0][:shopping].length == 2 && budget_list[1][:shopping].length == 2
  end

  def valid_number_of_products?(budget_list)
    budget_list[0][:shopping][0][:products].length == 1 &&
    budget_list[0][:shopping][1][:products].length == 2 &&
    budget_list[1][:shopping][0][:products].length == 1 &&
    budget_list[1][:shopping][1][:products].length == 3
  end

  def prepare_data_to_full_test
    budget_1 = Budget.create!(name: "budget1" )
    budget_2 = Budget.create!(name: "budget2" )
    payment1 = Payment.create!(value: 100, budget_id: budget_1.id )
    payment2 = Payment.create!(value: 200, budget_id: budget_1.id )
    payment3 = Payment.create!(value: 300, budget_id: budget_2.id )
    shopping_1 = Shopping.create!(budget_id: budget_1.id, start_date: Date.today )
    shopping_2 = Shopping.create!(budget_id: budget_1.id, start_date: Date.today )
    shopping_3 = Shopping.create!(budget_id: budget_2.id, start_date: Date.today )
    shopping_4 = Shopping.create!(budget_id: budget_2.id, start_date: Date.today )
    product1 = Product.create!(name: "product1", bar_code: "111" )
    product2 = Product.create!(name: "product2", bar_code: "222" )
    product3 = Product.create!(name: "product3", bar_code: "333" )
    product4 = Product.create!(name: "product4", bar_code: "444" )
    product5 = Product.create!(name: "product5", bar_code: "555" )
    product6 = Product.create!(name: "product6", bar_code: "666" )
    product7 = Product.create!(name: "product7", bar_code: "777" )
    price1 = Price.create!(value: 10, product_id: product1.id )
    price2 = Price.create!(value: 20, product_id: product2.id )
    price3 = Price.create!(value: 30, product_id: product3.id )
    price4 = Price.create!(value: 40, product_id: product4.id )
    price5 = Price.create!(value: 50, product_id: product5.id )
    price6 = Price.create!(value: 60, product_id: product6.id )
    price7 = Price.create!(value: 70, product_id: product7.id )
    purchase1 = Purchase.create!(price_id: price1.id, shopping_id: shopping_1.id, product_id: product1.id )
    purchase2 = Purchase.create!(price_id: price2.id, shopping_id: shopping_2.id, product_id: product2.id )
    purchase3 = Purchase.create!(price_id: price3.id, shopping_id: shopping_2.id, product_id: product3.id )
    purchase4 = Purchase.create!(price_id: price4.id, shopping_id: shopping_3.id, product_id: product4.id )
    purchase5 = Purchase.create!(price_id: price5.id, shopping_id: shopping_4.id, product_id: product5.id )
    purchase6 = Purchase.create!(price_id: price6.id, shopping_id: shopping_4.id, product_id: product6.id )
    purchase7 = Purchase.create!(price_id: price7.id, shopping_id: shopping_4.id, product_id: product7.id )
    localization1 = Localization.create!(latitude: 1, longitude: 11, price_id: price1.id )
    localization2 = Localization.create!(latitude: 2, longitude: 12, price_id: price2.id )
    localization3 = Localization.create!(latitude: 3, longitude: 13, price_id: price3.id )
    localization4 = Localization.create!(latitude: 4, longitude: 14, price_id: price4.id )
    localization5 = Localization.create!(latitude: 5, longitude: 15, price_id: price5.id )
    localization6 = Localization.create!(latitude: 6, longitude: 16, price_id: price6.id )
    localization7 = Localization.create!(latitude: 7, longitude: 17, price_id: price7.id )
    [budget_1,budget_2]
  end

  def prepare_full_data_overview_object
    budgets = prepare_data_to_full_test
    @prepare_budget_overview_object.prepare_for_budgets(budgets).get_overview_list

  end
end