require 'rails_helper'

feature "Public access to user info", type: :feature do
  before do
   @user = FactoryGirl.create(:user, first_name: "Teppo", last_name: "Testaaja")
   FactoryGirl.create(:rank, limit: 0)
  end
  scenario "visitor is able to load user show" do
    visit user_path(@user) 
    expect(page).to have_content "Teppo Testaaja"
  end
  scenario "visitor is able to load users game list" do
    visit user_path(@user)
    click_link "Game List"
    expect(page).to have_content "Gaming History"
  end
end
