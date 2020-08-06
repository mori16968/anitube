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

# 管理ユーザー
User.create!(name:  "管理者",
             email: "admin@example.com",
             password:              "12345678",
             password_confirmation: "12345678",
             admin: true)

# ユーザープロフィール画像
users = User.order(:id).take(12)
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

# お気に入り
users = User.order(:id).take(8)
posts = Post.order(:id).take(15)
posts.each do |post|
  users.each do |user|
    post.favorite(user) unless user.id == post.user_id
  end
end

# コメント
CSV.foreach('db/csv/comment.csv', headers: true) do |row|
  user_id = row[0]
  post_id = row[1]
  body = row[2]
  Comment.create!(
    user_id: user_id,
    post_id: post_id,
    body: body,
    created_at: rand(Time.zone.yesterday.beginning_of_day..Time.zone.yesterday.end_of_day))
end

# ゲストユーザー設定
guest = User.create!(name:  "ゲストユーザー",
             email: "guest@example.com",
             password:              "12345678",
             password_confirmation: "12345678"
            )
# ゲストの投稿
CSV.foreach("db/csv/guest_post.csv", headers: true) do |row|
  guest.posts.create!(
    youtube_url: row['youtube_url'],
    title: row['title'],
    body: row['body'],
    created_at: rand(Time.zone.yesterday.beginning_of_day..Time.zone.yesterday.end_of_day)
  )
end
# ゲストのリレーションシップ
users = User.all
following = users[2..10]
followers = users[3..20]
following.each { |followed| guest.follow(followed) }
followers.each { |follower| follower.follow(guest) }
# ゲストのお気に入り
posts = Post.order(:id).take(10)
posts.each do |post|
  post.favorite(guest) unless guest.id == post.user_id
end

# Youtube API
GOOGLE_API_KEY = ENV['MY_GOOGLE_API_KEY']

  params = URI.encode_www_form({
    part:  "snippet",
    key: GOOGLE_API_KEY,
    maxResults:  "30",
    q: 'PV',
    type:  'video',
    order: :relevance,
    published_after: 3.month.ago.iso8601,
    video_category_id: 1
  })
  uri = URI.parse("https://www.googleapis.com/youtube/v3/search?#{params}")
  response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
    http.get(uri.request_uri)
  end
  result = JSON.parse(response.body)

  result['items'].each do |item|
    title = item['snippet']['title']
    url = item['id']['videoId']
    date = item['snippet']['publishedAt']
    thumbnail = item['snippet']['thumbnails']['high']['url']
    movie = Video.new(
      title: title,
      url: url,
      date: date,
      thumbnail: thumbnail
    )
    movie.save
  end


