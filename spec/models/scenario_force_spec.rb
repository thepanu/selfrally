require 'rails_helper'

RSpec.describe Counter, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:scenario_force)).to be_valid
  end
end
