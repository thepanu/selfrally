require 'rails_helper'


feature "Maps", type: :feature do
  
  before do
    @map = FactoryBot.create(:map)
  end

  context "when not logged in" do

    scenario "can see #index" do
      visit maps_path
      expect(page).to have_content @map.name
    end

    scenario "can see #show" do
      visit map_path(@map)
      expect(page).to have_content @map.name
    end

    scenario "can't #new" do
      visit new_map_path
      expect(page).to have_content "Permission Denied"
    end

    scenario "can't #edit" do
      visit edit_map_path(@map)
      expect(page).to have_content "Permission Denied"
    end
  end

  context "when logged in" do

    before do
      @user = FactoryBot.create(:user)
      @user.confirm
      visit new_user_session_path
      fill_in "user_email", with: @user.email
      fill_in "user_password", with: @user.password
      click_button "Log in"    
    end

    scenario "can #new/create" do
      visit maps_path
      expect(page).to have_content "Add new Map"
      click_link "Add new Map"
      fill_in "map_name", with: 'Just a Test  Map'
      click_button 'Save'
      expect(page).to have_content 'Just a Test'
    end

    scenario "can #edit" do
      map = FactoryBot.create(:map)
      visit map_path(map)
      click_link "Edit"
      expect(page).to have_content "Editing"
      fill_in "map_name", with: "Edited name"
      click_button "Save"
      expect(page).to have_content "Edited name"
    end
  end

  context "when logged in as admin" do

    before do
      @user = FactoryBot.create(:user, roles: [:admin])
      @user.confirm
      visit new_user_session_path
      fill_in "user_email", with: @user.email
      fill_in "user_password", with: @user.password
      click_button "Log in"    
    end

    scenario "can #destroy", js: true do
      map = FactoryBot.create(:map)
      visit map_path(map)
      click_link "Delete"
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_content map.name
      expect(page).to have_content "destroyed"
    end
  end
end
