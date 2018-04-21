require 'rails_helper'

describe "user registration" do
  it "allows new users to sign up with valid email and password" do
    visit new_user_registration_path
    fill_in "Email", with: "hello@yahoo.com"
    fill_in "Password", with: "whatagreatpassword"
    fill_in "Password confirmation", with: "whatagreatpassword"
    click_button "Sign up"

    expect(page).to have_content("Please set your timezone.")
  end

  it "does not allow new users to sign up with invalid information" do
    visit new_user_registration_path
    fill_in "Email", with: "hey@yahoo.com"
    fill_in "Password", with: "whatagreatpassword"
    fill_in "Password confirmation", with: "nottherightpassword"
    click_button "Sign up"

    expect(page).to have_content("Password confirmation doesn't match")
  end

end

describe "user log in/log out" do
  before do
    @user = FactoryGirl.create(:user)
  end

  it "allows users to log in after sign up and log out" do

    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Log in"

    expect(page).to have_content("Signed in successfully.")
    expect(page).to have_content(@user.email)
    click_link "Log Out"

    expect(page).to have_content("Signed out successfully.")
  end

  it "does not allow user to sign in with wrong password" do
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: 'wrongpassword'
    click_button "Log in"

    expect(page).to have_content("Invalid email or password.")
    expect(page).to_not have_link("Log Out")

  end

  it "allows users to login with GitHub" do
    visit new_user_session_path
    expect(page).to have_link("Log In With GitHub")
  end

end
