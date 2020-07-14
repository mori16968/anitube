module LogInHelpers
  def log_in(user)
    visit new_user_session_path

    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end
end
