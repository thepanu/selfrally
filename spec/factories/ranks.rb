FactoryBot.define do
  factory :rank do
    sequence(:limit) { |n| n }
    sequence(:name) { |n| "Arvo#{n}" }
    img 'ranks/alok.gif'
  end
end
