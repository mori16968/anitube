require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let!(:user) { create(:user) }

  it "ログインページにアクセスできること" do
    visit root_path

    click_link 'ログイン'
    expect(current_path).to eq new_user_session_path
  end

  context "フォームの入力値が有効な場合" do
    it "ログインが成功し、ログアウトが可能になること" do
      log_in(user)

      expect(page).to have_content 'ログインしました。'
      expect(page).to have_selector 'header', text: '投稿する'
      expect(page).to have_selector 'header', text: 'マイページ'
      expect(page).to have_selector 'header', text: '通知'
      expect(page).to have_selector 'header', text: 'ログアウト'
      expect(current_path).to eq user_path(user.id)
    end
  end

  context "フォームの入力値が無効な場合" do
    it "ログインが失敗すること" do
      visit new_user_session_path

      fill_in 'メールアドレス', with: 'invalid_user@exemple.com'
      fill_in 'パスワード', with: 'invalidpass'
      click_button 'ログイン'

      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      expect(current_path).to eq new_user_session_path
    end
  end
end
