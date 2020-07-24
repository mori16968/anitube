require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { create(:post) }

  it "postが投稿可能であること" do
    expect(post).to be_valid
  end

  it "user_idが存在しないpostは無効であること" do
    post.user_id = nil
    expect(post).not_to be_valid
  end

  it "youtube_urlが存在しないpostは無効であること" do
    post.youtube_url = nil
    post.valid?
    expect(post.errors.added?(:youtube_url, :blank)).to be_truthy
  end

  it "titleが存在しないpostは無効であること" do
    post.title = nil
    post.valid?
    expect(post.errors.added?(:title, :blank)).to be_truthy
  end

  it "titleが空欄のpostは無効であること" do
    post.title = " "
    post.valid?
    expect(post.errors.added?(:title, :blank)).to be_truthy
  end

  it "titleが21文字以上ののpostは無効であること" do
    post.title = "a" * 21
    post.valid?
    expect(post.errors.added?(:title, :too_long, count: 20)).to be_truthy
  end

  it "bodyが存在しないpostは無効であること" do
    post.body = nil
    post.valid?
    expect(post.errors.added?(:body, :blank)).to be_truthy
  end

  it "bodyが空欄のpostは無効であること" do
    post.body = " "
    post.valid?
    expect(post.errors.added?(:body, :blank)).to be_truthy
  end

  it "bodyが141文字以上のpostは無効であること" do
    post.body = "a" * 201
    post.valid?
    expect(post.errors.added?(:body, :too_long, count: 200)).to be_truthy
  end
end
