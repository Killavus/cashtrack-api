class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :value
      t.references :product, index: true

      t.timestamps
    end
  end
end
