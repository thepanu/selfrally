require 'rails_helper'

RSpec.describe UpdateRatings do

  context "basics" do
    before do
      @play = FactoryGirl.create(:game_player, user: FactoryGirl.create(:user)) 
      @opponents_play = FactoryGirl.create(:game_player, user: FactoryGirl.create(:user)) 
      @game = FactoryGirl.create(:game, status: "finished")
    end
    it "can be created" do
      expect { UpdateRatings.new(game: @game) }.to_not raise_error
    end

    it "can be called" do
      expect { UpdateRatings.call(game: @game) }.to_not raise_error
    end

  end

  context "when players have less or more games than PROVISIONAL_LIMIT" do

    before do
      @red = FactoryGirl.create(:user)
      @blue = FactoryGirl.create(:user)
      @game = FactoryGirl.create(:game, :status => 1)
      @game.game_players << FactoryGirl.create(:game_player, user: @red, winner: true)
      @game.game_players << FactoryGirl.create(:game_player, user: @blue)
      UpdateRatings.call(game: @game)
    end

    it "updates ratings for provisional game_players" do
      expect(@red.rating_on_date(@game.date + 1.week)).to eql(1516)
    end

    it "doesn't update rating for established player when against provisional" do
      green = FactoryGirl.create(:user)
      (PROVISIONAL_LIMIT + 1).times do
        game = FactoryGirl.create(:game, status: 1)
        game.game_players << FactoryGirl.create(:game_player, user: green, winner: true)
        game.game_players << FactoryGirl.create(:game_player)      
        UpdateRatings.call(game: game) 
      end
      green.game_players.last.update_attributes(new_rating: 1500)
      game = FactoryGirl.create(:game, status: 1)
      game.game_players << FactoryGirl.create(:game_player, user: green, winner: true)
      game.game_players << FactoryGirl.create(:game_player, user: @blue)
      UpdateRatings.call(game: game)
      expect(green.rating_on_date(game.date + 1.week)).to eql(1500)
    end
  end


end
