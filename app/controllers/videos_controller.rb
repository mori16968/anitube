class VideosController < ApplicationController
  GOOGLE_API_KEY = ENV['MY_GOOGLE_API_KEY']

  def find_videos(keyword, after: 1.months.ago, before: Time.now)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = GOOGLE_API_KEY

    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      max_results: 8,
      order: :relevance,
      page_token: next_page_token,
      published_after: 3.month.ago.iso8601,
      video_category_id: 1
    }
    service.list_searches(:snippet, opt)
  end

  def index
    @youtube_data = find_videos('アニメ 公式 PV')
  end

  def show
  end
end
