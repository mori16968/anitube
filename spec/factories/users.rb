FactoryBot.define do
  factory :user do
    name { "yamada" }
    email { "yamada@yamada.com" }
    password { "yamadadesu" }
    password_confirmation { "yamadadesu" }
  end
end
