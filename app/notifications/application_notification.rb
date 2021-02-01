class ApplicationNotification < Noticed::Base
  # Delivery methods and helpers used by all notifications can be defined here.

  deliver_by :database, format: :to_database

  # Include the user's personal account by default, but allow overriding with params
  # Useful if you want to enable acts_as_tenant on the notification model
  def to_database
    {
      account: params[:account] || recipient.personal_account,
      type: self.class.name,
      params: params.except(:account)
    }
  end
end
