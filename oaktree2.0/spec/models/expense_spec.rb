require 'rails_helper'

describe Expense do

  before do
    @budget = FactoryGirl.create(:budget)
    @category = FactoryGirl.create(:category, budget: @budget)
    @expense = FactoryGirl.create(:expense, cost: 10, category: @category)
  end

  context 'associations' do

    it 'belongs to a category' do
      expect(@expense.category).to eq(@category)
    end

    it 'adds to category subtotal and budget total when created' do
      expect(@budget.total_expense).to eq(@expense.cost)
      expect(@category.subtotal).to eq(@expense.cost)

      second_expense = FactoryGirl.create(:expense, cost: 5.00, category: @category)
      expect(@budget.total_expense).to eq(@expense.cost + second_expense.cost)
      expect(@category.subtotal).to eq(@expense.cost + second_expense.cost)
    end

    it 'adjusts category subtotal and budget total when edited' do
      @expense.update(cost: 3.00)
      expect(@budget.total_expense).to eq(@expense.cost)
      expect(@category.subtotal).to eq(@expense.cost)
    end

    it 'removes from category subtotal and budget total when deleted' do
      expect(@budget.total_expense).to eq(@expense.cost)
      expect(@category.subtotal).to eq(@expense.cost)

      @expense.destroy
      expect(@budget.total_expense).to eq(0.00)
      expect(@category.subtotal).to eq(0.00)
    end

  end

  context 'validations' do

    it 'is invalid without a description' do
      new_expense = Expense.new(cost: 5.00, category: @category)
      expect(new_expense).to have(1).error_on(:description)
    end

    it 'is invalid without a cost' do
      new_expense = Expense.new(description: "soda", category: @category)
      expect(new_expense).to have(2).error_on(:cost)
    end

    it 'requires a numerical cost' do
      new_expense = Expense.new(description: "Soda", category: @category, cost: "Whee!")
      expect(new_expense).to have(1).error_on(:cost)
    end

    it 'is invalid without a category' do
      new_expense = Expense.new(description: "soda", cost: 5.00)
      expect(new_expense).to have(1).error_on(:category)
    end

  end

  context 'percentages' do

    it 'knows its percentage of a category' do
      expect(@expense.category_percentage).to eq(100)
      new_expense = FactoryGirl.create(:expense, category: @category, cost: 5)
      expect(@expense.category_percentage).to eq(67)
    end

  end

end
