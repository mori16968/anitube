class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications
    @notifications.where(checked: false).order(id: "DESC").each do |notification|
      notification.update_attributes(checked: true)
    end
  end
end
