require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "it is invalid without a user" do
    comment = FactoryBot.build(:comment, user_id: nil)
    expect(comment).to_not be_valid
  end

  it "it is invalid without a commentable item" do
    comment = FactoryBot.build(:comment, commentable_id: nil)
    expect(comment).to_not be_valid
  end
end
