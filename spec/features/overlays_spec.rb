require 'rails_helper'


feature "Overlays", type: :feature do
  
  before do
    @overlay = FactoryBot.create(:overlay)
  end

  context "when not logged in" do

    scenario "can see #index" do
      visit overlays_path
      expect(page).to have_content @overlay.name
    end

    scenario "can see #show" do
      visit overlay_path(@overlay)
      expect(page).to have_content @overlay.name
    end

    scenario "can't #new" do
      visit new_overlay_path
      expect(page).to have_content "Permission Denied"
    end

    scenario "can't #edit" do
      visit edit_overlay_path(@overlay)
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
      visit overlays_path
      expect(page).to have_content "Add new Overlay"
      click_link "Add new Overlay"
      fill_in "overlay_name", with: 'Just a Test  Overlay'
      click_button 'Save'
      expect(page).to have_content 'Just a Test'
    end

    scenario "can #edit" do
      overlay = FactoryBot.create(:overlay)
      visit overlay_path(overlay)
      click_link "Edit"
      expect(page).to have_content "Editing"
      fill_in "overlay_name", with: "Edited name"
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
      overlay = FactoryBot.create(:overlay)
      visit overlay_path(overlay)
      click_link "Delete"
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_content overlay.name
      expect(page).to have_content "destroyed"
    end
  end
end
