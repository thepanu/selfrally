require 'rails_helper'
RSpec.describe ScenarioPublication, type: :model do
  it "has valid factory" do
    expect(FactoryBot.build(:scenario_publication)).to be_valid
  end
end
