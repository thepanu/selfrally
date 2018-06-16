require 'rails_helper'

feature "Public access to user info", type: :feature do
  before do
    FactoryGirl.create(:rank)
    @scenario = FactoryGirl.create(:scenario)
    scenario_force_initiative = FactoryGirl.create(:scenario_force_with_initiative)
    scenario_force_second = FactoryGirl.create(:scenario_force)
    @scenario.scenario_forces << scenario_force_initiative 
    @scenario.scenario_forces << scenario_force_second
    @user = FactoryGirl.create(:user, first_name: "Teppo", last_name: "Testaaja")
    FactoryGirl.create(:rank, limit: 0)
    @game = FactoryGirl.create(:game, scenario_id: @scenario.id)
    @game.game_players << FactoryGirl.create(:game_player, user_id: @user.id, force_id: scenario_force_initiative.force_id)
    @game.game_players << FactoryGirl.create(:game_player, user_id: @user.id, force_id: scenario_force_second.force_id)
  end
  scenario "visitor is able to load user show" do
    visit user_path(@user) 
    expect(page).to have_content "Teppo Testaaja"
  end

  scenario "visitor is able to load users game list" do
    visit user_path(@user)
    click_link "Game List"
    expect(page).to have_content @game.id
    expect(page).to have_content @user.full_name
  end
end
