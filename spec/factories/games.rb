FactoryGirl.define do
  factory :game do
    date Time.now
    turnsplayed 5
    gamingtime 5
    status 0
    association :scenario
  end
end
