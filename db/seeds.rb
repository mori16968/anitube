# ユーザー
50.times do |n|
  name = Faker::Name.name
  email = "test#{n + 1}@test.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               )
end

# ユーザープロフィール画像
users = User.order(:id).take(10)
users.each_with_index do |user, i|
  user.avatar.attach(io: File.open(Rails.root.join("db/fixtures/avatar-#{i + 1}.jpg")), filename: "avatar-#{i + 1}.jpg")
  user.save
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..30]
followers = users[3..20]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }