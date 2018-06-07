FactoryGirl.define do
  factory :user_rank do
    promotion_date Time.now
    association :user
    association :rank
  end
end
