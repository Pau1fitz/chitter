require 'spec_helper'

feature "User can add a cheet" do

  before(:each) {
    Cheet.create(:text => "My first cheet")
  }

    scenario "when opening the home page" do
      visit('/')
      expect(page).to have_content("My first cheet")
    end
end

