module Users
  module SubscriptionStatus
    extend ActiveSupport::Concern

    included do
      helper_method :subscribed?
      helper_method :not_subscribed?
    end

    def subscribed?
      user_signed_in? && current_user.subscribed?
    end

    def not_subscribed?
      !subscribed?
    end
  end
end
