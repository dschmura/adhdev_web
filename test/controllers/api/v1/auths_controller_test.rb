require "test_helper"

class AuthsControllerTest < ActionDispatch::IntegrationTest
  test "returns unauthorized if user not valid" do
    post api_v1_auth_url
    assert_response :unauthorized

    user = users(:one)
    post api_v1_auth_url, params: {email: user.email, password: "invalidpassword"}
    assert_response :unauthorized
  end

  test "returns an api token on successful auth" do
    user = users(:one)
    post api_v1_auth_url, params: {email: user.email, password: "password"}
    assert_response :success
    assert_not_nil response.parsed_body["token"]
  end

  test "creates a new api token if one didn't exist" do
    user = users(:one)
    tokens_count = user.api_tokens.count

    post api_v1_auth_url, params: {email: user.email, password: "password"}
    assert_response :success
    assert_equal user.api_tokens.find_by(name: "default").token, response.parsed_body["token"]

    # It should create a new API token with the name of the application
    assert_equal tokens_count + 1, user.api_tokens.count
  end
end
