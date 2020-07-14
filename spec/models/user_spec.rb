require 'rails_helper'

RSpec.describe User, type: :model do
  it "name,email,passwordがあれば有効であること" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "nameが無ければ無効であること" do
    user = build(:user, name: nil)
    expect(user).not_to be_valid
  end

  it "nameが13文字以上なら無効であること" do
    user = build(:user, name: "a" * 13)
    expect(user).not_to be_valid
  end

  it "emailが無ければ無効であること" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it "重複したemailが無効であること" do
    user = create(:user)
    other_user = build(:user, email: user.email)
    expect(other_user).not_to be_valid
  end

  it "passwordが無ければ無効であること" do
    user = build(:user, password: nil)
    expect(user).not_to be_valid
  end

  it "password_confirmationが無ければ無効であること" do
    user = build(:user, password_confirmation: '')
    expect(user).not_to be_valid
  end

  it "passwordが5文字以下ならば無効であること" do
    user = build(:user, password: "yama")
    expect(user).not_to be_valid
  end
end
