require 'rails_helper'

RSpec.describe ScenarioCounter, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:scenario_counter)).to be_valid
  end
end
