FactoryBot.define do
  factory :comment do |comment|
    comment.body "MyText"
    comment.association :user
#    association :scenario
    comment.commentable { |a| a.association(:scenario) }
#    association :parent
  end
end
