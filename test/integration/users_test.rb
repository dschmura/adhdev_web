require 'test_helper'

class Jumpstart::UsersTest < ActionDispatch::IntegrationTest
  test "user can delete their account" do
    sign_in users(:one)
    assert_difference "User.count", -1 do
      delete "/users"
    end
    assert_redirected_to root_path
  end
end
