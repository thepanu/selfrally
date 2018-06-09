FactoryGirl.define do
  factory :publisher do
    sequence(:name) { |n| "Testi Julkaisija#{n}" }
  end
end
