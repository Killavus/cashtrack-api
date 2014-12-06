class ChangePriceColumnToPriceId < ActiveRecord::Migration
  def change
    remove_column :purchases, :price, :integer
    add_column :purchases, :price_id, :integer

  end
end
