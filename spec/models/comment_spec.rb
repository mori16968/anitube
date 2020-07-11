require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }

  it "コメントが有効であること" do
    expect(comment).to be_valid
  end

  it "user_idが存在しないコメントは無効であること" do
    comment.user_id = nil
    expect(comment).not_to be_valid
  end
  
  it "post_idが存在しないコメントは無効であること" do
    comment.post_id = nil
    expect(comment).not_to be_valid
  end

  it "bodyが存在しないコメントは無効であること" do
    comment.body = nil
    comment.valid?
    expect(comment.errors.added?(:body, :blank)).to be_truthy
  end

  it "bodyが空欄のコメントは無効であること" do
    comment.body = " "
    comment.valid?
    expect(comment.errors.added?(:body, :blank)).to be_truthy
  end

  it "bodyが141字以上のコメントは無効であること" do
    comment.body = "a" * 141
    comment.valid?
    expect(comment.errors.added?(:body, :too_long, count: 140)).to be_truthy
  end
end
