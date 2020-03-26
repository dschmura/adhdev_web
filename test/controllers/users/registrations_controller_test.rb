require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include InvisibleCaptcha

  setup do
    @user_params = {user:
                        {name: "Test User",
                         username: "new_testuser",
                         email: "user@test.com",
                         password: "TestPassword",
                         terms_of_service: "1"}}
  end

  class BasicRegistrationTest < Users::RegistrationsControllerTest
    test "successfully registration form render" do
      get new_user_registration_path
      assert_response :success
      assert response.body.include?("user[name]")
      assert response.body.include?("user[email]")
      assert response.body.include?("user[password]")
      assert response.body.include?(InvisibleCaptcha.sentence_for_humans)
    end

    test "successful user registration" do
      assert_difference "User.count" do
        post user_registration_url, params: @user_params
      end
    end

    test "failed user registration" do
      assert_no_difference "User.count" do
        post user_registration_url, params: {}
      end
    end
  end

  class InvibleCaptchaTest < Users::RegistrationsControllerTest
    test "honeypot is not filled and user creation succeeds" do
      assert_difference "User.count" do
        post user_registration_url, params: @user_params.merge(honeypotx: "")
      end
    end

    test "honeypot is filled and user creation fails" do
      assert_no_difference "User.count" do
        post user_registration_url, params: @user_params.merge(honeypotx: "spam")
      end
    end
  end
end
