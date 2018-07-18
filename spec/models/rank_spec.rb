require 'rails_helper'

RSpec.describe Rank, type: :model do
  it "has valid factory" do
    expect(FactoryBot.build(:rank)).to be_valid
  end
end
