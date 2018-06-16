FactoryGirl.define do
  factory :scenario do
    name "Raatteen tie"
    scenario_date "1940-1-1"
    gameturns 4
    association :location
#    association :scenario_publications
#    association :publishers
    factory :scenario_with_forces do 
      after(:create) do |scenario|
        FactoryGirl.create(:scenario_force, scenario: scenario)
        FactoryGirl.create(:scenario_force_with_initiative, scenario: scenario)
      end
    end
  end
end
