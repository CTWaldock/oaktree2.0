require 'rails_helper'

describe 'budget index' do

  before do
    @user = FactoryGirl.create(:user)
    @active_budget = FactoryGirl.create(:budget, user: @user)
    @inactive_budget = FactoryGirl.create(:budget, start_date: Date.current - 1, user: @user)
    @completed_budget = FactoryGirl.create(:budget, start_date: Date.current - 1, end_date: Date.current, user: @user)
    Capybara.javascript_driver = :webkit
  end

  it 'has a link to create an new budget' do
    login_as(@user, :scope => :user)
    visit user_budgets_path
    expect(page).to have_link("Create a New Budget")
  end


  it 'shows the user their list of active budgets', :js => true do
    login_as(@user, :scope => :user)
    visit user_budgets_path
    expect(page).to have_content("Active Budgets")
    expect(page).to have_link(@active_budget.name)
  end

  it 'shows the user budgets that have not yet started', :js => true do
    login_as(@user, :scope => :user)
    visit user_budgets_path
    expect(page).to have_content("Inactive Budgets")
    expect(page).to have_link(@inactive_budget.name)
  end

  it 'shows the user their list of past budgets', :js => true do
    login_as(@user, :scope => :user)
    visit user_budgets_path
    expect(page).to have_content("Completed Budgets")
    expect(page).to have_link(@completed_budget.name)
  end

end
