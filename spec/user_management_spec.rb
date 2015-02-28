require 'spec_helper'

feature 'user signs up' do

  scenario "when a new user visits the site" do
    expect{ sign_up }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, Paul")
    expect(User.first.email).to eq("paul@example.com")
  end

  scenario "attempts to sign in with a password that doesn't match" do
    expect{ sign_up('Paul', 'paul', 'wrong_password', 'paul', 'paul@paul.com')}.to change(User, :count).by 0
    expect(current_path).to eq('/users')
    expect(page).to have_content("Sorry, your passwords don't match")
  end

  def sign_up(name = "Paul",
              password ="paul",
              password_confirmation = "paul",
              username = "paulychops",
              email = "paul@example.com")
    visit('/users/new')
    expect(page.status_code).to eq(200)
    fill_in :name, :with => name
    fill_in :password, :with => password
    fill_in :password_confirmation, :with => password_confirmation
    fill_in :username, :with => username
    fill_in :email, :with => email
    click_button "Sign up"
  end

end