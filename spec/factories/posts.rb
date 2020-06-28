FactoryBot.define do
  factory :post do
    youtube_url { "https://youtu.be/CgaLT9oNPwk" }
    title { "頑張ろう日本" }
    body { "頑張りましょうよジャパン" }
    association :user
  end
end
