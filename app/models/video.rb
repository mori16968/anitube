class Video < ApplicationRecord
  GOOGLE_API_KEY = ENV['MY_GOOGLE_API_KEY']
  params = URI.encode_www_form({
    part:  "snippet",
    key: 'GOOGLE_API_KEY',
    maxResults:  "8",
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


end
