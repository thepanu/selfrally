require 'rails_helper'

RSpec.describe ScenarioForce, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:scenario_force)).to be_valid
  end
end
