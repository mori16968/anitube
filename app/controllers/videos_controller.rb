class VideosController < ApplicationController
  MAX_PER_PAGE= 12

  def index
    @videos = Video.page(params[:page]).per(MAX_PER_PAGE)
  end

  def show
    @video = Video.find(params[:id])
  end
end
