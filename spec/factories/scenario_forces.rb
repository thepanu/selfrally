FactoryBot.define do
  factory :scenario_force do
    association :scenario
    association :force
    initiative 0

    factory :scenario_force_with_initiative do
      initiative 1
    end

  end
end
