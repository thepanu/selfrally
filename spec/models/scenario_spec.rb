require 'rails_helper'

RSpec.describe Scenario, type: :model do
  it "is valid with a date, scenario and status" do
    scen = FactoryGirl.build(:scenario)
    expect(scen).to be_valid
  end
  
end
