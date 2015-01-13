class CreateBudgetCloseds < ActiveRecord::Migration
  def change
    create_table :budget_closeds do |t|
      t.references :budget, index: true

      t.timestamps
    end
  end
end
