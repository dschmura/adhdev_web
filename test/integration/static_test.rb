require "test_helper"

class Jumpstart::StaticTest < ActionDispatch::IntegrationTest
  test "homepage" do
    get root_path
    assert_response :success
  end

  test "dashboard" do
    sign_in users(:one)
    get root_path
    assert_select "h1", "Dashboard"
  end
end
