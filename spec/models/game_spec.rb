require 'rails_helper'

RSpec.describe Game, type: :model do
  it "is valid with a date, scenario and status" do
    game = FactoryGirl.build(:game)
    expect(game).to be_valid
  end

  it "is not valid if date is missing" do
    game = FactoryGirl.build(:game, :date => nil)
    expect(game).to_not be_valid
  end

  it "has participants (game_players)" do
    game = FactoryGirl.create(:game)
    game.game_players << FactoryGirl.create(:game_player)
    game.game_players << FactoryGirl.create(:game_player)
    expect(game.no_players?).to be false
  end

  it "can tell the player with given initiative" do
    scen = FactoryGirl.create(:scenario_with_forces)
    game = FactoryGirl.create(:game, scenario: scen)
    game.scenario.scenario_forces.each do |force|
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:game_player, game: game, force: force.force, user: user)
    end
    expect(game.player_by_initiative(1)).to_not eql(game.player_by_initiative(0))
  end

end
