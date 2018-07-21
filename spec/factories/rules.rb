FactoryBot.define do
  factory :rule do
    sequence(:name) { |n| "Rule#{n}" } 
#    association :ribbon
  end
end
