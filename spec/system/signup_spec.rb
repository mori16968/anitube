require 'rails_helper'

RSpec.describe "Signup", type: :system do

  let!(:user) do
     create(:user,
       name: "test_user",
       email: "test_user@exemple.com",
       password: "password",
       password_confirmation: "password")
  end

  it "新規登録ページにアクセスできること" do
    visit root_path

    click_link "新規登録"
    expect(current_path).to eq new_user_registration_path
    expect(page).to have_content "新規ユーザー登録"
  end

  context "フォームの入力値が有効な場合" do

    it "ユーザーの新規作成が成功すること" do
      visit new_user_registration_path

      fill_in 'ユーザー名(12文字以内)', with: 'yamada'
      fill_in 'メールアドレス', with: 'yamada@example.com'
      fill_in 'パスワード', with: 'yamayamada'
      fill_in 'パスワード（確認用）', with: 'yamayamada'
      click_button 'アカウント登録'

      expect(current_path).to eq root_path
      expect(page).to have_content 'アカウント登録が完了しました。'
      expect(page).to have_selector 'header', text: '投稿する'
      expect(page).to have_selector 'header', text: 'マイページ'
      expect(page).to have_selector 'header', text: '通知'
      expect(page).to have_selector 'header', text: 'ログアウト'
    end
  end

  context "フォームの入力値が無効な場合" do
    it "ユーザーの新規作成が失敗すること" do
      visit new_user_registration_path

      fill_in 'ユーザー名(12文字以内)', with: 'a' * 13
      fill_in 'メールアドレス', with: 'test_user@exemple.com'
      fill_in 'パスワード', with: 'yama'
      fill_in 'パスワード（確認用）', with: 'kawa'
      click_button 'アカウント登録'

      expect(page).to have_content 'ユーザー名は12文字以内で入力してください'
      expect(page).to have_content 'メールアドレスはすでに存在します'
      expect(page).to have_content 'パスワード（確認用）とパスワードの入力が一致しません'
      expect(page).to have_content 'パスワードは6文字以上で入力してください'
    end
  end
end
