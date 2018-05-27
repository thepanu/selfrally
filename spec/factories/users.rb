FactoryGirl.define do
  factory :user do
    first_name "Antti"
    last_name "Aslaaja"
    nick "anttiaslaaja"
    sequence(:email) { |n| "example#{n}@example.com" }
    password "testi-passu"
  end
end
