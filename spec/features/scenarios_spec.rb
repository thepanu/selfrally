require 'rails_helper'


feature "Scenarios", type: :feature do
  
  before do
    @scenario = FactoryBot.create(:scenario_with_forces)
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
      @user = FactoryBot.create(:user)
      @user.confirm
      visit new_user_session_path
      fill_in "user_email", with: @user.email
      fill_in "user_password", with: @user.password
      click_button "Log in"    
      @publication = FactoryBot.create(:publication)
      @location = FactoryBot.create(:location)
      @side_a = FactoryBot.create(:force)
      @side_b = FactoryBot.create(:force)
    end

    scenario "can #new/create/edit" do
      visit scenarios_path
      expect(page).to have_content "Add new Scenario"
      click_link "Add new Scenario"
      fill_in "scenario_name", with: 'Just a Test Scenario'
      fill_in 'scenario_gameturns', with: 5.5
      fill_in 'scenario_location', with: @location.id
      choose('scenario_initiative_index_0')
      select(@side_a.name, from: 'scenario_scenario_forces_attributes_0_force_id')
      select(@side_b.name, from: 'scenario_scenario_forces_attributes_1_force_id')
      click_button 'Save'
      expect(page).to have_content 'Just a Test'
      click_link 'Edit'
      fill_in 'scenario_name', with: 'New name'
      click_button 'Save'
      expect(page).to have_content 'New name'
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
      scenario = FactoryBot.create(:scenario_with_forces)
      visit scenario_show_path(scenario)
      click_link 'Delete' 
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content "destroyed"
    end
  end
end
