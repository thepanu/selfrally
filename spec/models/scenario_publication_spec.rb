require 'rails_helper'
RSpec.describe ScenarioPublication, type: :model do
  it "has valid factory" do
    expect(FactoryGirl.build(:scenario_publication)).to be_valid
  end
end
