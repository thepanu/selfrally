FactoryBot.define do
  factory :overlay do
    sequence(:name) { |n| "MyString#{n}" }
  end
end
