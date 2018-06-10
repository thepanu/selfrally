require 'rails_helper'

RSpec.describe Rule, type: :model do
  it "has valid factory" do
    expect(FactoryGirl.create(:rule)).to be_valid  
  end
end
