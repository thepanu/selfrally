FactoryGirl.define do
  factory :game do
    date Date.today
    turnsplayed 5
    gamingtime 5
    status 0
    association :scenario
  end
end
