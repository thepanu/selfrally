FactoryGirl.define do
  factory :scenario do
    name "Raatteen tie"
    scenario_date "1940-1-1"
    gameturns 4
    association :location
#    association :publication
#    association :publisher
  end
end
