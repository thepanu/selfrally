FactoryBot.define do
  factory :map do
    sequence(:name) { |n|  "MyString#{n}" }
  end
end
