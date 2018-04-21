require 'rails_helper'

describe 'budget show' do

  before do
    @user = FactoryGirl.create(:user)
    @budget = FactoryGirl.create(:budget, user: @user)
    @first_category = @budget.categories.first
    @second_category = FactoryGirl.create(:category, title: "Gas", budget: @budget)
  end

  context 'budget' do

    it 'does not allow users to view budgets that do not belong to them' do
      other_user = FactoryGirl.create(:user, email: "jim@yahoo.com")
      login_as(other_user, :scope => :user)
      visit budget_path(@budget)

      expect(page).to have_content("You don't have access to that budget.")
      expect(page).to_not have_content(@budget.name)
    end

    it 'shows users remaining budget' do
      login_as(@user, :scope => :user)
      visit budget_path(@budget)

      expect(page).to have_content("Expenditure Limit: $10,000.00")
      expect(page).to have_content("Current Expenditure: $0.00")
      expect(page).to have_content("Remaining Expenditure: $10,000.00")

      FactoryGirl.create(:expense, category: @first_category, cost: 1000.00)
      visit budget_path(@budget)

      expect(page).to have_content("Expenditure Limit: $10,000.00")
      expect(page).to have_content("Current Expenditure: $1,000.00")
      expect(page).to have_content("Remaining Expenditure: $9,000.00")
      expect(page).to have_content("$300")
    end

    it 'has a link to edit the budget' do
      login_as(@user, :scope => :user)
      visit budget_path(@budget)

      expect(page).to have_link("Edit Budget Specifications")
    end

    it 'should inform the user regarding its status' do
      login_as(@user, :scope => :user)
      visit budget_path(@budget)
      expect(page).to have_content("Budget in progress")

      @budget.update(start_date: Date.today + 1)
      visit budget_path(@budget)
      expect(page).to have_content("This budget is not yet active.")

      @budget.update(start_date: Date.today - 5, end_date: Date.today - 3)
      visit budget_path(@budget)
      expect(page).to have_content("This budget has been completed.")
    end

  end

  context 'categories' do

    before do
      FactoryGirl.create(:expense, cost: 1000.00, category: @first_category)
      FactoryGirl.create(:expense, cost: 1000.00, category: @second_category)
      FactoryGirl.create(:expense, cost: 500.00, category: @second_category)
      login_as(@user, :scope => :user)
      visit budget_path(@budget)
    end


    it 'shows user categorical expenditure breakdown' do


      expect(page).to have_content("Category")
      expect(page).to have_content("% of Expenditure Limit")
      expect(page).to have_content("% of Current Expenditure")

      expect(page).to have_content("Food")
      expect(page).to have_content("10%")
      expect(page).to have_content("40%")


      expect(page).to have_content("Gas")
      expect(page).to have_content("15%")
      expect(page).to have_content("60%")
    end

    it 'allows users to click on a link to access category show page' do


      expect(page).to have_link("Food")
      expect(page).to have_link("Gas")

      click_link("Food", match: :first)

      expect(page.current_path).to eq category_path(@first_category)
    end
  end

  context 'expenses' do

    before do
      15.times { |i| FactoryGirl.create(:expense, description: "Expense #{i + 1}", cost: 20 - i, category: @first_category) }
      login_as(@user, :scope => :user)
      visit budget_path(@budget)
    end

    it 'shows users top five expenses' do
      expect(page).to have_content("Expense 1")
      expect(page).to have_content("Expense 5")

      expect(page).to_not have_content("Expense 8")
      expect(page).to_not have_content("Expense 7")
    end

    it 'shows users five most recent expenses' do
      expect(page).to have_content("Expense 15")
      expect(page).to have_content("Expense 11")

      expect(page).to_not have_content("Expense 6")
      expect(page).to_not have_content("Expense 10")
    end

  end
end
