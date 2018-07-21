require 'rails_helper'

RSpec.describe UpdateRibbonScores do

  context "basics" do
    before do
      @user = FactoryBot.create(:user)
      @rule = FactoryBot.create(:rule)
      @ribbon = FactoryBot.create(:ribbon)
      @ribbon.rules << @rule
      @scenario = FactoryBot.create(:scenario)
      @scenario.rules << @rule
      @game = FactoryBot.create(:game, scenario: @scenario)
      @game.game_players << FactoryBot.create(:game_player, user: @user)
    end

    it "can be created" do
      expect { UpdateRibbonScores.new(user: @user, ribbons: @game.ribbons) }.to_not raise_error
    end

    it "can be called" do
      expect { UpdateRibbonScores.call(user: @user, ribbons: @game.ribbons) }.to_not raise_error
    end 

    it "creates user_ribbon if none exists" do
      UpdateRibbonScores.call(user: @user, ribbons: @game.ribbons)
      expect(@user.ribbons.include?(@ribbon)).to be true
    end

    it "adds points to user_ribbon" do
      UpdateRibbonScores.call(user: @user, ribbons: @game.ribbons)
      expect(@user.user_ribbons.first.points).to eql(1)
    end

    it "assigns correct badgeclass after one relevant game" do
      UpdateRibbonScores.call(user: @user, ribbons: @game.ribbons)
      expect(@user.user_ribbons.first.badgeclass).to eql("nq")
    end

    it "assigns correct badgeclass after 11 games" do
      10.times do 
        game = FactoryBot.create(:game, scenario: @scenario)
        game.game_players << FactoryBot.create(:game_player, user: @user)
      end
      UpdateRibbonScores.call(user: @user, ribbons: @game.ribbons)
      expect(@user.user_ribbons.first.badgeclass).to eql("bronze")
    end
  end

end
