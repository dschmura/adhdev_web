class AcceptedInvite < ApplicationNotification
  deliver_by :action_cable, format: :to_websocket

  def to_websocket
    {
      html: ApplicationController.render(partial: "notifications/notification", locals: {notification: self})
    }
  end

  def message
    t "notifications.invite_accepted", user: user.name
  end

  def url
    account_path(params[:account])
  end

  def user
    params[:user]
  end
end
