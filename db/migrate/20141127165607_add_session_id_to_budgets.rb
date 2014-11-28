class AddSessionIdToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :session_id, :integer
  end
end
