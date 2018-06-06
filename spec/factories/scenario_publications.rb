FactoryGirl.define do
  factory :scenario_publication do
    association :scenario
    association :publication
  end
end
