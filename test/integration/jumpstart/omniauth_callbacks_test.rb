require 'test_helper'

class Jumpstart::OmniauthCallbacksTest < ActionDispatch::IntegrationTest
  setup do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(provider: 'twitter', uid: '12345', info: { email: "twitter@example.com" }, credentials: { token: 1 })
  end

  teardown do
    OmniAuth.config.mock_auth[:twitter] = nil
  end

  test "can register and login with a social account" do
    get "/users/auth/twitter/callback"

    user = User.last
    assert_equal "twitter@example.com", user.email
    assert_equal "twitter", user.connected_accounts.last.provider
    assert_equal "12345", user.connected_accounts.last.uid
    assert_equal user, controller.current_user

    sign_out user
    get "/"

    assert_nil controller.current_user
    get "/users/auth/twitter/callback"

    assert_equal user, controller.current_user
  end

  test "can connect a social account when signed in" do
    user = users(:one)

    sign_in user
    get "/users/auth/twitter/callback"

    assert_equal "twitter", user.connected_accounts.twitter.last.provider
    assert_equal "12345", user.connected_accounts.twitter.last.uid
  end

  test "Cannot login with social if email is taken but not connected yet" do
    user = users(:one)
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(provider: 'twitter', uid: '12345', info: { email: user.email }, credentials: { token: 1 })

    get "/users/auth/twitter/callback"

    assert user.connected_accounts.twitter.none?
    assert_equal "We already have an account with this email. Login with your previous account before connecting this one.", flash[:alert]
  end
end
