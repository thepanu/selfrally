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
end
