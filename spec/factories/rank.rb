FactoryGirl.define do
  factory :rank do
    sequence(:name) { |n| "Sotilasarvo #{n}" }
    sequence(:limit) { |n| n }
  end
end
