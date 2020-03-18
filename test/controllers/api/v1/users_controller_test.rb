require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "returns errors if invalid params submitted" do
    post api_v1_users_url, params: {}
    assert_response :success
    assert response.parsed_body["errors"]
    assert_equal ["can't be blank"], response.parsed_body["errors"]["email"]
  end

  test "returns user and api token on success" do
    email = "api-user@example.com"
    post api_v1_users_url, params: {user: {email: email, name: "API User", password: "password", password_confirmation: "password", terms_of_service: "1"}}
    assert_response :success
    assert response.parsed_body["user"]
    assert_equal email, response.parsed_body["user"]["email"]
    assert_not_nil response.parsed_body["user"]["api_tokens"].first["token"]
  end
end
