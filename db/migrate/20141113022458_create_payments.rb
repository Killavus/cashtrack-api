class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :value
      t.references :budget, index: true

      t.timestamps
    end
  end
end
