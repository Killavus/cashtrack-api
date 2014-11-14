class CreateShoppings < ActiveRecord::Migration
  def change
    create_table :shoppings do |t|
      t.date :start_date
      t.date :end_date
      t.references :budget, index: true

      t.timestamps
    end
  end
end
