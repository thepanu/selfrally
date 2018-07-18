require 'rails_helper'

RSpec.describe Counter, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:counter)).to be_valid
  end

  it "outputs the combination of name and type" do
    expect(FactoryBot.build(:counter).to_s).to eql("Counter Type")
  end
end
