module Users
  module TimeZone
    extend ActiveSupport::Concern

    included do
      helper_method :browser_time_zone
      around_action :set_time_zone
    end

    def browser_time_zone
      browser_tz = ActiveSupport::TimeZone.find_tzinfo(cookies[:browser_time_zone])
      ActiveSupport::TimeZone.all.find { |zone| zone.tzinfo == browser_tz } || Time.zone
    rescue TZInfo::UnknownTimezone, TZInfo::InvalidTimezoneIdentifier
      Time.zone
    end

    def set_time_zone
      if user_signed_in? && current_user.time_zone?
        Time.use_zone(current_user.time_zone) { yield }
      else
        yield
      end
    end
  end
end
