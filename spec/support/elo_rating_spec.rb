require 'rails_helper'

RSpec.describe EloRating, type: :model do

  before do
    @favourite = EloRating.new(2400)
    @underdog = EloRating.new(2000)
  end

  it "returns argument error if no argument supplied" do
    expect { EloRating.new }.to raise_error(ArgumentError)
  end

  it "return correct current rating" do
    expect(EloRating.new(1500).current_rating).to eql(1500)
  end

  it "returns the correct expected score against player" do
    expect(@favourite.expected_score_against(@underdog.current_rating).round(5)).to eql(0.90909)
  end

  it "returns the correct delta if favourite won" do
    delta = @favourite.delta(1, @underdog.current_rating)
    expect(delta).to eql(2.9)
  end

  it "returns correct new rating after win for underdog" do
    new_rating = @underdog.new_rating(1, @favourite.current_rating)
    expect(new_rating).to eql(2029.1)
  end
end
