require 'rails_helper'

describe Category do

  before do
    @budget = FactoryGirl.create(:budget)
    @category = @budget.categories.first
  end

  context 'associations' do

    describe 'budget' do

      it 'belongs to a budget' do
        expect(@category.budget).to eq(@budget)
      end

      it 'subtracts its subtotal from budget when deleted' do
        FactoryGirl.create(:expense, category: @category)
        expect(@budget.total_expense).to eq(10.50)
        @category.destroy
        expect(@budget.total_expense).to eq(0)
      end

    end

    describe 'expenses' do

      it 'has many expenses' do
        expect(@category).to respond_to(:expenses)
      end

      it 'destroys its expenses upon deletion' do
        expense = FactoryGirl.create(:expense, category: @category)
        @category.destroy
        expect(Expense.all).to_not include(expense)
      end

    end

  end

  describe 'percentage information' do

    before do
      @category_2 = FactoryGirl.create(:category, title: "Gas", budget: @budget)
      FactoryGirl.create(:expense, description: "Very Expensive Pizza", cost: 1000, category: @category)
    end

    it 'knows its current percentage of a budget' do
      expect(@category.current_percentage).to eq(100)
      FactoryGirl.create(:expense, description: "Very Expensive Gas", cost: 4000, category: @category_2)
      expect(@category.current_percentage).to eq(20)
      expect(@category_2.current_percentage).to eq(80)
    end

    it 'knows its total maximum percentage of a budget' do
      expect(@category.total_percentage).to eq(10)
    end

  end

end
