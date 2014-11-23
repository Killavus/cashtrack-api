class AddBarCodeToProduct < ActiveRecord::Migration
  def change
    add_column :products, :bar_code, :string
  end
end
