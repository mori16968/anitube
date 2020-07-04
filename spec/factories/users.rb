FactoryBot.define do
  factory :user do
    name { "yamada" }
    sequence(:email) { |n| "yamada#{n}@yamada.com" }
    password { "yamadadesu" }
    password_confirmation { "yamadadesu" }
  end
end
