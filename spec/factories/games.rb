FactoryBot.define do
  factory :game do
    sequence(:date) { |n| Time.now + n.hours }
    turnsplayed 5
    gamingtime 5
    status 0
    association :scenario
   # association :game_players
  end
end
