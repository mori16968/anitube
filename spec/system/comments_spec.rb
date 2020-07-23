require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:user) { create(:user) }
  let!(:post) { create(:post) }

  before do
    log_in(user)
    find('#index-post').click
    find('.thumbnail').click
  end

  it "コメントを作成、削除できること" do
    # コメント投稿
    find(".text_field").set("こんにちは")
    click_button 'コメント'

    expect(page).to have_content 'こんにちは'
    expect(page).to have_content 'コメントを投稿しました'

    # コメント削除
    click_link '削除'

    expect(page).not_to have_content 'こんにちは'
    expect(page).to have_content 'コメントを削除しました'
  end

  xit "141字以上のコメントは投稿できないこと" do
    find(".text_field").set("#{a * 141}")
    click_button 'コメント'

    expect(page).to have_content 'コメントは140文字以内で入力してください'
  end
end
