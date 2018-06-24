require 'rails_helper'


feature "Scenarios", type: :feature do
  
  before do
    @scenario = FactoryGirl.create(:scenario_with_forces)
  end

  context "when not logged in" do

    scenario "can see #index" do
      visit scenarios_path
      expect(page).to have_content @scenario.name
    end

    scenario "can see #show" do
      visit scenario_show_path(@scenario)
      expect(page).to have_content @scenario.name
    end

    scenario "can't #new" do
      visit new_scenario_path
      expect(page).to have_content "Permission Denied"
    end

    scenario "can't #edit" do
      visit scenario_edit_path(@scenario)
      expect(page).to have_content "Permission Denied"
    end
  end

  context "when logged in" do

    before do
      @user = FactoryGirl.create(:user)
      @user.confirm
      visit new_user_session_path
      fill_in "user_email", with: @user.email
      fill_in "user_password", with: @user.password
      click_button "Log in"    
      @publication = FactoryGirl.create(:publication)
      @location = FactoryGirl.create(:location)
    end

    scenario "can #new/create" do
      visit scenarios_path
      expect(page).to have_content "Add new Scenario"
      click_link "Add new Scenario"
      fill_in "scenario_name", with: 'Just a Test Scenario'
      fill_in 'scenario_gameturns', with: 5.5
      fill_in 'scenario_location', with: @location.id
      click_button 'Save'
      expect(page).to have_content 'Just a Test'
    end

    scenario "can #edit" do
      scenario = FactoryGirl.create(:scenario)
      visit scenario_show_path(scenario)
      click_link "Edit"
      expect(page).to have_content "Editing"
      fill_in "scenario_name", with: "Edited name"
      click_button "Save"
      expect(page).to have_content "Edited name"
    end
  end

  context "when logged in as admin" do

    before do
      @user = FactoryGirl.create(:user, roles: [:admin])
      @user.confirm
      visit new_user_session_path
      fill_in "user_email", with: @user.email
      fill_in "user_password", with: @user.password
      click_button "Log in"    
    end

    scenario "can #destroy", js: true do
      scenario = FactoryGirl.create(:scenario)
      visit scenario_show_path(scenario)
      click_link "Destroy"
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_content scenario.name
      expect(page).to have_content "destroyed"
    end
  end
end
