require 'rails_helper'

RSpec.describe UserRank, type: :model do
  it "has valid factory" do
    expect(FactoryBot.build(:user_rank)).to be_valid
  end
end
