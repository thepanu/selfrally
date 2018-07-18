FactoryBot.define do
  factory :force do
    sequence(:name) { |n| "Test Force #{n}" }
  end
end
