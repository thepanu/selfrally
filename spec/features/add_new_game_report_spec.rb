require 'rails_helper'


feature "Games#new", type: :feature do
  before do
    @scenario = FactoryBot.create(:scenario_with_forces)
    @user = FactoryBot.create(:user)
    @opponent = FactoryBot.create(:user, first_name: "Antero")
    @user.confirm
    FactoryBot.create(:rank, limit: 5)
  end

  # This won't run in vim, run in external terminal
  scenario "Log in and add new report", js: true do
    visit new_user_session_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    click_button "Log in"
    click_link "Add a game report"
    select(Time.now.day + 1, from: 'game_date_3i')
    select2(@scenario.name, {from: 'scenario-select'})
    fill_in "game_gamingtime", with: 1
    fill_in "game_turnsplayed", with: 5
    click_button "Create new"
    expect(page).to have_content "Editing"
    choose('game_status_finished')
    choose('game_winner_index_0')
    select2(@user.full_name, {from: 'player-select-1'})
    select2(@opponent.full_name, {from: 'player-select-2'})
    click_button "Save changes"
    expect(page).to have_content @user.full_name
    expect(page).to have_content "Loser"
    expect(page).to have_content "Winner"
  end
end
