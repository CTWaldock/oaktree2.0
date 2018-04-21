require 'rails_helper'

describe 'budget creation' do

  before do
    @user = FactoryGirl.create(:user)
  end

  it 'requires users to have a timezone before allowing them to access the budget creation page' do
    @user.update(time_zone: nil)
    login_as(@user, :scope => :user)
    visit new_budget_path
    expect(page).to have_content("Timezone Settings")
  end

  it 'allows users with timezones to access the budget creation page' do
    login_as(@user, :scope => :user)
    visit new_budget_path
    expect(page).to have_content("Budget Specifications")
  end

  it 'does not create a budget with invalid parameters' do
    login_as(@user, :scope => :user)
    visit new_budget_path
    click_button ("Create Budget")

    expect(page).to have_content("Please enter valid information.")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Limit can't be blank")
    expect(page).to have_content("Limit is not a number")
    expect(page).to have_content("Start date can't be blank")
    expect(page).to have_content("End date can't be blank")
    expect(page).to have_content("Categories can't be blank")

  end

  it 'creates a valid budget and redirects to its show page' do
    login_as(@user, :scope => :user)
    visit new_budget_path
    fill_in "Name", with: "House Construction Project"
    fill_in "Limit", with: 500000
    fill_in "Start date", with: Date.current
    fill_in "End date", with: Date.current + 200
    fill_in "budget[categories_attributes][0][title]", with: "Materials"
    fill_in "budget[categories_attributes][1][title]", with: "Labor"
    click_button ("Create Budget")

    expect(page).to have_content("House Construction Project")
    expect(Budget.last.categories.count).to eq(2)
    expect(page).to_not have_content("Please enter valid information.")
  end

end
