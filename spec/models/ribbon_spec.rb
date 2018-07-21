require 'rails_helper'

RSpec.describe Ribbon, type: :model do
  it "has valid factory" do
    expect(FactoryBot.create(:ribbon)).to be_valid
  end

  it "has rules" do
    rule = FactoryBot.create(:rule)
    ribbon = FactoryBot.create(:ribbon)
    ribbon.rules << rule
    expect(ribbon.rules).to include(rule)
  end

  it "can be assigned to a user" do
    user = FactoryBot.create(:user)
    ribbon = FactoryBot.create(:ribbon)
    user.ribbons << ribbon
    expect(user.ribbons).to include(ribbon)
  end
end
