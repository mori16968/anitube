require 'rails_helper'

RSpec.describe "Posts", js: true, type: :system do
  let!(:user) { create(:user) }

  describe "ログインしたユーザーが投稿を作成、編集、削除する" do
    before do
      log_in(user)
      click_link '投稿する'
    end

    it "新規投稿を作成、編集、削除できること" do
      # 新規投稿
      fill_in '動画URL', with: 'https://youtu.be/Zzv42rrtUbM'
      fill_in 'タイトル', with: 'リゼロ二期'
      fill_in '本文', with: 'とても楽しみ'
      click_button '投稿'

      post = Post.first
      aggregate_failures do
        expect(post.youtube_url).to eq 'https://youtu.be/Zzv42rrtUbM'
        expect(post.title).to eq 'リゼロ二期'
        expect(post.body).to eq 'とても楽しみ'
        expect(current_path).to eq posts_path
        expect(page).to have_content '投稿が完了しました'
      end

      # 編集
      find('.thumbnail').click
      expect(current_path).to eq post_path(post.id)
      click_link '編集'
      expect(current_path).to eq edit_post_path(post.id)
      expect(page).to have_content '投稿編集'

      fill_in '本文', with: 'あまり楽しみでない'
      click_button '更新'

      expect(current_path).to eq post_path(post.id)
      expect(page).to have_content 'あまり楽しみでない'
      expect(page).not_to have_content 'とても楽しみ'
      expect(page).to have_content '投稿の編集が完了しました'

      # 削除
      page.accept_confirm do
        click_link '削除'
      end
      sleep 2
      expect(current_path).to eq posts_path
      expect(page).not_to have_content 'リゼロ二期'
      expect(Post.where(id: post.id)).to be_empty
      expect(page).to have_content '投稿の削除が完了しました'
    end

    it "無効な入力値だと投稿の作成に失敗すること" do
      fill_in '動画URL', with: 'https://youtu.be/Zzv42rrtUbM'
      fill_in 'タイトル', with: 'a' * 31
      fill_in '本文', with: 'a' * 141
      click_button '投稿'

      expect(page).to have_content '無効な項目があります'
      expect(page).to have_content 'タイトルは30文字以内で入力してください'
      expect(page).to have_content '本文は140文字以内で入力してください'
    end
  end
end
