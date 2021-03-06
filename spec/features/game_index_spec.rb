require 'rails_helper'

feature "Game reports", type: :feature do
  before do
    @scenario = FactoryBot.create(:scenario_with_forces)
    @game = FactoryBot.create(:game, :scenario => @scenario)
    @game.scenario.scenario_forces.each do |force|
      FactoryBot.create(:game_player, game: @game, force: force.force)
    end
  end

  scenario "Can visit list of reports and click on a single report" do
    visit games_path
    click_link @game.id
    expect(page).to have_content @game.id

  end
end
