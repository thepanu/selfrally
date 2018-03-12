FactoryGirl.define do
  factory :publication do
    name "Testi Julkaisu"
    publishing_year 2017
    association :publisher
  end
end
