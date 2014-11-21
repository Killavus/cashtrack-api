class AddPurchaseidColumnToProduct < ActiveRecord::Migration
  def change
    add_column :products, :purchase_id, :integer
  end
end
