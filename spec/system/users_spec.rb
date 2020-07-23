require 'rails_helper'

RSpec.describe "Users", type: :system, js: true do
  let(:user) { create(:user) }
  let!(:admin_user) do
    create(:user,
           name: 'Admin',
           email: 'admin@example.com',
           password: '12345678',
           password_confirmation: '12345678',
           admin: true)
  end

  it "管理ユーザーが別のユーザーを削除できること" do
    log_in(admin_user)
    click_link 'ユーザー一覧'
    click_link user.name
    expect(current_path).to eq user_path(user.id)

    page.accept_confirm do
      click_link 'ユーザーを削除'
    end
    sleep 2
    expect(current_path).to eq users_path
    expect(User.where(id: user.id)).to be_empty
    expect(page).to have_content 'ユーザーの削除が完了しました'
  end
end
