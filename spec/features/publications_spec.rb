require 'rails_helper'


feature "Publications", type: :feature do
  
  before do
    @publication = FactoryBot.create(:publication)
  end

  context "when not logged in" do

    scenario "can see #index" do
      visit publications_path
      expect(page).to have_content @publication.name
    end

    scenario "can see #show" do
      visit publication_show_path(@publication)
      expect(page).to have_content @publication.name
    end

    scenario "can't #new" do
      visit new_publication_path
      expect(page).to have_content "Permission Denied"
    end

    scenario "can't #edit" do
      visit publication_edit_path(@publication)
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
      @publisher = FactoryBot.create(:publisher)
    end

    scenario "can #new/create" do
      visit publications_path
      expect(page).to have_content "Add new Publication"
      click_link "Add new Publication"
      fill_in "publication_name", with: 'Just a Test Publication'
      fill_in "publication_publishing_year", with: 1996
      select(@publisher.name, from: "publication_publisher")
      click_button 'Save'
      expect(page).to have_content 'Just a Test'
    end

    scenario "can #edit" do
      publication = FactoryBot.create(:publication)
      visit publication_show_path(publication)
      click_link "Edit"
      expect(page).to have_content "Editing"
      fill_in "publication_name", with: "Edited name"
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
      publication = FactoryBot.create(:publication)
      visit publication_show_path(publication)
      click_link "Delete"
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_content publication.name
      expect(page).to have_content "destroyed"
    end
  end
end
