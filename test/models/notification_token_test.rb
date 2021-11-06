require "test_helper"

class NotificationTokenTest < ActiveSupport::TestCase
  test "ios" do
    assert_includes NotificationToken.ios, notification_tokens(:ios)
  end

  test "android" do
    assert_includes NotificationToken.android, notification_tokens(:android)
  end
end
