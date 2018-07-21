FactoryBot.define do
  factory :publication do
    sequence(:name) { |n| "Testi Julkaisu#{n}" }
    publishing_year 2017
    association :publisher

    factory :publication_alternate_name do
      name "Vaihtoehto"
    end
  end
end
