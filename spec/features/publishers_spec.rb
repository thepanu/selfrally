require 'rails_helper'


feature "Publishers", type: :feature do
  
  before do
    @publisher = FactoryGirl.create(:publisher)
  end

  context "when not logged in" do

    scenario "can see #index" do
      visit publishers_path
      expect(page).to have_content @publisher.name
    end

    scenario "can see #show" do
      visit publisher_show_path(@publisher)
      expect(page).to have_content @publisher.name
    end

    scenario "can't #new" do
      visit new_publisher_path
      expect(page).to have_content "Permission Denied"
    end

    scenario "can't #edit" do
      visit publisher_edit_path(@publisher)
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
    end

    scenario "can #new/create" do
      visit publishers_path
      expect(page).to have_content "Add new Publisher"
      click_link "Add new Publisher"
      fill_in "publisher_name", with: 'Just a Test  Publisher'
      click_button 'Save'
      expect(page).to have_content 'Just a Test'
    end

    scenario "can #edit" do
      publisher = FactoryGirl.create(:publisher)
      visit publisher_show_path(publisher)
      click_link "Edit"
      expect(page).to have_content "Editing"
      fill_in "publisher_name", with: "Edited name"
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
      publisher = FactoryGirl.create(:publisher)
      visit publisher_show_path(publisher)
      click_link "Destroy"
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_content publisher.name
      expect(page).to have_content "destroyed"
    end
  end
end
