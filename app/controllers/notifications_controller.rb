class NotificationsController < ApplicationController
  before_action :authenticate_user!
  after_action :mark_as_read, only: [:index]

  def index
    @pagy, @notifications = pagy(current_user.notifications.where(account: current_account).newest_first)
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_interacted!
    redirect_to @notification.to_notification.url
  end

  private

  def mark_as_read
    @notifications.mark_as_read!
  end
end
