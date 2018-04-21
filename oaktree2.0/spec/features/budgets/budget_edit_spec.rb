require 'rails_helper'

describe 'budget edit' do

  before do
    @user = FactoryGirl.create(:user)
    @budget = FactoryGirl.create(:budget, user: @user)

  end

  it 'allows users to edit budget details' do
    login_as(@user, :scope => :user)
    visit edit_budget_path(@budget)

    expect(page).to have_field("Name", with: "My Budget")
    expect(page).to have_field("budget[categories_attributes][0][title]", with: "Food")

    fill_in "Name", with: ""
    fill_in "budget[categories_attributes][0][title]", with: ""
    fill_in "budget[categories_attributes][1][title]", with: "Labor"
    click_button "Update Budget"

    expect(page).to have_content("Please enter valid information.")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_field("budget[categories_attributes][0][title]", with: "Food")
    expect(page).to have_field("budget[categories_attributes][1][title]", with: "Labor")

    fill_in "Name", with: "House Construction Project"
    fill_in "budget[categories_attributes][0][title]", with: "Materials"
    fill_in "budget[categories_attributes][1][title]", with: "Labor"

    click_button "Update Budget"
    expect(page).to have_content("House Construction Project")
    expect(Budget.last.categories.count).to eq(2)
    expect(page).to_not have_content("Please enter valid information.")
  end

  it 'does not allow users to edit budgets that do not belong to them' do
    other_user = FactoryGirl.create(:user, email: "otheruser@user.com")
    login_as(other_user, :scope => :user)
    visit edit_budget_path(@budget)

    expect(page).to have_content("You don't have access to that budget.")
  end

end
