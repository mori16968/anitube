FactoryBot.define do
  factory :comment do
    body { 'テストコメント' }
    association :post
    user { post.user }
  end
end
