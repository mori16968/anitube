require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  let(:user) { create(:user) }
  let(:other_user) do
    create(:user,
           name: 'Alice',
           email: 'alice@example.com',
           password: 'pass_alice',
           password_confirmation: 'pass_alice')
  end

  before do
    log_in(user)
    visit user_path(other_user.id)
  end

  it "ユーザーが他のユーザーに対してフォロー、フォロー解除できること" do
    # フォローする
    find('.follow-btn').click
    expect(page).to have_selector '.unfollow-btn'
    expect(other_user.followers.count).to eq 1
    expect(user.followings.count).to eq 1

    # いいねを解除する
    find('.unfollow-btn').click
    expect(page).to have_selector '.follow-btn'
    expect(other_user.followers.count).to eq 0
    expect(user.followings.count).to eq 0
  end
end
