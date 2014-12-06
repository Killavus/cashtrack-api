class RemovePurchaseIdFromProduct < ActiveRecord::Migration
  def change
    remove_column :products, :purchase_id, :integer
  end
end
