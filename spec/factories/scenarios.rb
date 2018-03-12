FactoryGirl.define do
  factory :scenario do
    name "Raatteen tie"
    scenario_date "1940-1-1"
    gameturns 4
    location_id 1
    association :publication
  end
end
