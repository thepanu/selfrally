FactoryBot.define do
  factory :scenario_counter do
    association :scenario
#    association :force
    association :counter
  end
end
