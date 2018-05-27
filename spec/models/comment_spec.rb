require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it "it is invalid without a user" do
    comment = FactoryGirl.build(:comment, user_id: nil)
    expect(comment).to_not be_valid
  end

  it "it is invalid without a commentable item" do
    comment = FactoryGirl.build(:comment, commentable_id: nil)
    expect(comment).to_not be_valid
  end
end
