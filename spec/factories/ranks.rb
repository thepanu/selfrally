FactoryGirl.define do
  factory :rank do
    sequence(:limit) { |n| n }
    sequence(:name) { |n| "Arvo#{n}" }
  end
end
