class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :price
      t.references :shopping, index: true
      t.integer :shop_id

      t.timestamps
    end
  end
end
