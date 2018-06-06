require 'rails_helper'

RSpec.describe GamePlayer, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:game_player)).to be_valid
  end
end
