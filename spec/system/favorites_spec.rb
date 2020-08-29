require 'rails_helper'

RSpec.describe "Favorites", js: true, type: :system do
  let(:user) { create(:user) }
  let!(:post) { create(:post) }

  before do
    log_in(user)
    find('#logo').click
    find('.thumbnail').click
  end

  it "ユーザーが投稿に対していいね、いいね解除できること" do
    # いいねする
    find('.favorite-btn').click
    expect(page).to have_selector '.unfavorite-btn'
    expect(post.favorites.count).to eq 1

    # いいねを解除する
    find('.unfavorite-btn').click
    expect(page).to have_selector '.favorite-btn'
    expect(post.favorites.count).to eq 0
  end
end
