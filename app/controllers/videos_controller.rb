class VideosController < ApplicationController
  GOOGLE_API_KEY = 'AIzaSyB96X73K0OUQh8dgtImU1iKQ91e2dEXUg4'

  def find_videos(keyword, after: 1.months.ago, before: Time.now)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = GOOGLE_API_KEY

    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      max_results: 8,
      order: :date,
      page_token: next_page_token,
      published_after: after.iso8601,
      published_before: before.iso8601
    }
    service.list_searches(:snippet, opt)
  end

  def index
    @youtube_data = find_videos('アニメ 公式 PV')
  end

  def show
  end
end
