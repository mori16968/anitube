class VideosController < ApplicationController
  PER = 12

  def index
    @videos = Video.page(params[:page]).per(PER)
  end

  def show
    @video = Video.find(params[:id])
  end
end
