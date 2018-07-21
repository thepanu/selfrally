FactoryBot.define do
  factory :user_rank do
    sequence(:promotion_date) { |n| Time.now + n.days }
    association :user
    association :rank
  end
end
