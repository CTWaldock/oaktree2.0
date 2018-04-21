class AddTotalExpenseToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :total_expense, :float, default: 0.00
  end
end
