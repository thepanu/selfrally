require 'rails_helper'

RSpec.describe Ribbon, type: :model do
  it "has valid factory" do
    expect(FactoryGirl.create(:ribbon)).to be_valid
  end

  it "has rules" do
    rule = FactoryGirl.create(:rule)
    ribbon = FactoryGirl.create(:ribbon)
    ribbon.rules << rule
    expect(ribbon.rules).to include(rule)
  end

  it "can be assigned to a user" do
    user = FactoryGirl.create(:user)
    ribbon = FactoryGirl.create(:ribbon)
    user.ribbons << ribbon
    expect(user.ribbons).to include(ribbon)
  end
end
