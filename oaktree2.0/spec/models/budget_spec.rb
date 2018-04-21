require 'rails_helper'

describe Budget do

  before do
    @budget = FactoryGirl.create(:budget)
  end

  context 'associations' do

    describe 'user' do

      it 'has a user' do
        expect(@budget).to respond_to(:user)
      end

    end

    describe 'categories' do

      before do
        FactoryGirl.create(:expense, category: @budget.categories.first)
        category = FactoryGirl.create(:category, title: "Diamonds", budget: @budget)
        FactoryGirl.create(:expense, cost: 4000, description: "diamond", category: category)
      end

      it 'has many categories' do
        expect(@budget).to respond_to(:categories)
      end

      it 'knows how to order categories based on subtotal' do
        expect(@budget.categories.first.title).to_not eq("Diamonds")
        expect(@budget.ordered_categories.first.title).to eq("Diamonds")
      end

    end

    describe 'expenses' do

      before do
        FactoryGirl.create(:expense, category: @budget.categories.first)
        FactoryGirl.create(:expense, cost: 20, description: "Burger", category: @budget.categories.first)
        FactoryGirl.create(:expense, cost: 5, description: "Coke", category: @budget.categories.first)
      end

      it 'knows how to order expenses based on recency' do
        expect(@budget.most_recent_expenses.first.description).to eq("Coke")
        expect(@budget.most_recent_expenses.last.description).to eq("Pizza")
      end

      it 'knows how to order expenses based on price' do
        expect(@budget.top_five_expenses.first.description).to eq("Burger")
        expect(@budget.top_five_expenses.last.description).to eq("Coke")
      end

      it 'has many individual expenses through categories' do
        expect(@budget).to respond_to(:expenses)
      end

    end

  end

  context 'financial information' do

    it 'has a limit' do
      expect(@budget).to respond_to(:limit)
    end

    it 'has a total expense' do
      expect(@budget).to respond_to(:total_expense)
    end

    it 'knows remaining expense' do
      @budget.update(total_expense: 500.00)
      expect(@budget.remaining_expense).to eq(@budget.limit - @budget.total_expense)
    end

    it 'knows when the limit is exceeded' do
      expect(@budget.exceeded?).to eq(false)
      @budget.update(limit: 100.00, total_expense: 100.01)
      expect(@budget.exceeded?).to eq(true)
    end

    it 'has a daily spending average based on current total expenditure and time passed' do
      @budget.update(total_expense: 200.00)
      expect(@budget.average_expenditure).to eq(200.00)
      @budget.update(start_date: Date.current - 2)
      expect(@budget.average_expenditure).to eq(100.00)
    end

    it 'has a recommended daily expenditure limit to meet budget' do
      @budget.update(limit: 300.00)
      expect(@budget.recommended_expenditure).to eq(10)
      @budget.update(total_expense: 150.00)
      expect(@budget.recommended_expenditure).to eq(5)
    end

  end

  context 'date related information' do

    it 'knows remaining days left' do
      expect(@budget.remaining_days).to eq(30)
    end

    it 'knows when it is active' do
      expect(@budget.status).to eq("Active")
    end

    it 'knows when it is complete' do
      @budget.update(start_date: Date.current - 2, end_date: Date.current)
      expect(@budget.status).to eq("Complete")
    end

    it 'knows when it is inactive' do
      @budget.update(start_date: Date.current + 2)
      expect(@budget.status).to eq("Inactive")
    end

    it 'knows when it is completed' do
    end


  end

  context 'validations' do

    it 'does not allow start date to begin after end date' do
      new_budget = FactoryGirl.build(:budget, start_date: Date.current, end_date: Date.current - 1)
      expect(new_budget.save).to eq(false)
    end

    it 'requires dates' do
      new_budget = FactoryGirl.build(:budget, start_date: nil, end_date: nil)
      expect(new_budget).to have(1).error_on(:start_date)
      expect(new_budget).to have(1).error_on(:end_date)
    end

    it 'requires a limit' do
      new_budget = FactoryGirl.build(:budget, limit: nil)
      expect(new_budget).to have(2).error_on(:limit)
    end

    it 'requires limit to be a number' do
      new_budget = FactoryGirl.build(:budget, limit: "Hello!")
      expect(new_budget).to have(1).error_on(:limit)
    end

    it 'requires a name' do
      new_budget = FactoryGirl.build(:budget, name: "")
      expect(new_budget).to have(1).error_on(:name)
    end

  end

  context 'class scopes' do

    it 'knows which budgets are completed' do
      @budget.update(start_date: Date.current - 1, end_date: Date.current)
      expect(Budget.completed).to include(@budget)
    end

    it 'knows which budgets are in progress' do
      expect(Budget.active).to include(@budget)
    end

    it 'knows which budgets have not occurred yet' do
      @budget.update(start_date: Date.current + 1)
      expect(Budget.inactive).to include(@budget)
    end

  end

end
