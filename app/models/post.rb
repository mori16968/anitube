class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :youtube_url, presence: true
  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 200 }

  def favorite(user)
    favorites.create(user_id: user.id)
  end

  def cancel_favorite(user)
    favorites.find_by(user_id: user.id).destroy
  end

  def favorite?(user)
    favorite_users.include?(user)
  end

  def create_notification_favorite(current_user)
    temp = Notification.where([
      "visitor_id = ? and visited_id = ? and post_id = ? and action = ? ",
      current_user.id, user_id, id, "favorite",
    ])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: user_id,
        post_id: id,
        action: "favorite"
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment(current_user, comment_id)
    temp_ids = Comment.select(:user_id).
      where(post_id: id).
      where.not(user_id: current_user.id).
      distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: "comment"
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
