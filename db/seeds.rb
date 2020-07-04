require "csv"

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
  user.avatar.attach(io: File.open(Rails.root.join("db/fixtures/avatar/avatar-#{i + 1}.jpg")), filename: "avatar-#{i + 1}.jpg")
  user.save
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..30]
followers = users[3..20]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# Post
users = User.order(:id).take(5)
i = 0
(1).upto(5) do |n|
  CSV.foreach("db/csv/post_user_#{n}.csv", headers: true) do |row|
    users[i].posts.create!(
      youtube_url: row['youtube_url'],
      title: row['title'],
      body: row['body'],
      created_at: rand(Time.zone.yesterday.beginning_of_day..Time.zone.yesterday.end_of_day)
    )
  end
  i += 1
end
