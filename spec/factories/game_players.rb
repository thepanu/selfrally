FactoryGirl.define do
  factory :game_player do
    association :game
    association :user
    association :force
  end
end
