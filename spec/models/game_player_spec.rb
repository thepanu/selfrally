require 'rails_helper'

RSpec.describe GamePlayer, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:game_player)).to be_valid
  end
end
