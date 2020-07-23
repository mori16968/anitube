require 'rails_helper'

RSpec.describe "Posts", js: true, type: :system do
  describe "ログインしたユーザーが投稿を作成、編集、削除する" do
    let!(:user) { create(:user) }

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
      fill_in 'タイトル', with: 'a' * 13
      fill_in '本文', with: 'a' * 141
      click_button '投稿'

      expect(page).to have_content '無効な項目があります'
      expect(page).to have_content 'タイトルは12文字以内で入力してください'
      expect(page).to have_content '本文は140文字以内で入力してください'
    end
  end

  describe "フィードにフォローしたユーザーの投稿と自身の投稿が表示される" do
    let!(:alice) { create(:user, name: 'alice') }
    let!(:bob) { create(:user, name: 'bob') }
    let!(:carol) { create(:user, name: 'carol') }
    let!(:alice_post) { create(:post, user: alice, title: 'alice_title') }
    let!(:bob_post) { create(:post, user: bob, title: 'bob_title') }
    let!(:carol_post) { create(:post, user: carol, title: 'carol_title') }

    before do
      log_in(alice)
    end

    it "フィードに自身の投稿が表示されているか" do
      click_link 'フィード'

      expect(current_path).to eq feed_posts_path
      expect(page).to have_content 'alice_title'
      expect(page).not_to have_content 'bob_title'
      expect(page).not_to have_content 'carol_title'
    end

    it "他のユーザーをフォローするとフィードに表示,解除すると非表示になるか" do
      # フォローしてフィードページに移動する
      visit user_path(bob.id)
      click_button 'フォロー'
      click_link 'フィード'

      expect(current_path).to eq feed_posts_path
      expect(page).to have_content 'alice_title'
      expect(page).to have_content 'bob_title'
      expect(page).not_to have_content 'carol_title'

      # フォロー解除してフィードページに移動する
      visit user_path(bob.id)
      click_button 'フォロー解除'
      click_link 'フィード'

      expect(current_path).to eq feed_posts_path
      expect(page).to have_content 'alice_title'
      expect(page).not_to have_content 'bob_title'
      expect(page).not_to have_content 'carol_title'
    end
  end
end
