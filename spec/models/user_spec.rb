require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "is valid with a first name, last name, nick, email, and password" do
    user = User.new(
      first_name: "Antti",
      last_name: "Aslaaja",
      nick: "anttiaslaaja",
      email: "testi@self-rally.org",
      password: "testi-passu"
    )
    expect(user).to be_valid
  end
  
  it "is invalid without a first name" do
    user = FactoryBot.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end
  
  it "is invalid without a last name" do
    user = FactoryBot.build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end
  
  it "is invalid without an email address" do 
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")

  end
  
  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "same@example.com")
    user = FactoryBot.build(:user, email: "same@example.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "returns a user's full name as a string" do
    user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
    expect(user.full_name).to eq "John Doe"
  end

  context "rank related" do

    before do
      @time = Time.now
      @user = FactoryBot.create(:user)
      @rank_0 = FactoryBot.create(:rank, limit: 0)
      @rank_a = FactoryBot.create(:rank, limit: 1)
      @rank_b = FactoryBot.create(:rank, limit: 3)
      @rank_c = FactoryBot.create(:rank, limit: 99)
      @user.user_ranks << FactoryBot.create(:user_rank, rank_id: @rank_0.id, promotion_date: @time - 10.days)
    end
    it "outputs the current rank" do
      @user.user_ranks << FactoryBot.create(:user_rank, rank_id: @rank_a.id)
      @user.user_ranks << FactoryBot.create(:user_rank, rank_id: @rank_b.id)
      expect(@user.current_rank).to eql(@rank_b)
    end

    it "outputs the rank user had on a given date" do
      @user.user_ranks << FactoryBot.create(:user_rank, rank_id: @rank_a.id, promotion_date: Time.now - 1.week)
      @user.user_ranks << FactoryBot.create(:user_rank, rank_id: @rank_b.id, promotion_date: Time.now)
      expect(@user.rank_on_date(Time.now - 1.week)).to eql(@rank_a)
    end

    context "tells if user has reached a new rank" do
      it "when over the limit for new rank" do
        FactoryBot.create(:game).game_players << FactoryBot.create(:game_player, user_id: @user.id)
        expect(@user.promote?).to eql(true)
      end

      it "when under the limit for new rank" do
        @user.user_ranks << FactoryBot.create(:user_rank, rank_id: @rank_a.id)
        FactoryBot.create(:game).game_players << FactoryBot.create(:game_player, user_id: @user.id)
        expect(@user.promote?).to eql(false)
      end
    end
    
    context "promotion checks" do

      before do
        3.times do |i|
          @user.check_for_promotion(@time + i.days)
          game = FactoryBot.create(:game, status: 1, date: @time + i.days)
          game.game_players << FactoryBot.create(:game_player, user_id: @user.id)
        end
      end

      it "tells if user was due for promotion on given date" do
        expect(@user.promote_on_date?(@time + 2.days)).to eql(true)
      end

      it "tells if user was not due for promotion on given date" do
        @user.check_for_promotion(@time + 10.days)
        expect(@user.promote_on_date?(@time + 10.days)).to eql(false)
      end 
    end
  end

  context "ribbons" do
    before do
      @user = FactoryBot.create(:user)
      @rule = FactoryBot.create(:rule)
      @ribbon_a = FactoryBot.create(:ribbon)
      @ribbon_a.rules << @rule
    end

    it "can assign points to ribbons based on rules used" do
      @user.assign_points(@rule)
      expect(@user.user_ribbons.first.points).to eql(1)
    end 

    it "will raise badge class when over treshold" do
      40.times do
        @user.assign_points(@rule)
      end
      expect(@user.user_ribbons.first.badgeclass).to eql("gold")
    end
  end
end
