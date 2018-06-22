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

  it "ratings are not updated for provisional game" do
    game = FactoryGirl.create(:game, :status => 1)
    game.game_players << FactoryGirl.create(:game_player, :winner => true)
    game.game_players << FactoryGirl.create(:game_player)
    game.update_ratings
    expect(game.provisional).to eql(true)
    expect(game.game_players.first.user.rating_on_date(game.date + 1.week)).to eql(1500)
  end

  describe "Non-provisional ratings" do
    before do
      @red = FactoryGirl.create(:user)
      @blue = FactoryGirl.create(:user)
      10.times do
        game = FactoryGirl.create(:game, :status => 1)
        game.game_players << FactoryGirl.create(:game_player, :user_id => @red.id, :winner => true)
        game.game_players << FactoryGirl.create(:game_player, :user_id => @blue.id)
        game.update_ratings
      end
    end

    it "updates ratings for game_players after 10 games" do
      game = FactoryGirl.create(:game, :status => 1)
      game.game_players << FactoryGirl.create(:game_player, :user_id => @red.id, :winner => true)
      game.game_players << FactoryGirl.create(:game_player, :user_id => @blue.id)
      game.update_ratings
      
      expect(@red.rating_on_date(game.date + 1.week)).to eql(1516)
    end
  end
end
