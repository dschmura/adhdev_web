class ApplicationNotification < Noticed::Base
  # Delivery methods and helpers used by all notifications can be defined here.

  deliver_by :database, format: :to_database

  def to_database
    {
      account: params[:account],
      type: self.class.name,
      params: params
    }
  end
end
