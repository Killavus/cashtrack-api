class AddProductIdToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :product_id, :integer
  end
end
