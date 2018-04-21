class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.integer :budget_id
      t.float :subtotal, default: 0.00

      t.timestamps null: false
    end
  end
end
