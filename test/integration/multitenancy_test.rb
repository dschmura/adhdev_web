require "test_helper"

class Jumpstart::MultitenancyTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @account = accounts(:company)
    sign_in @user
  end

  test "domain multitenancy" do
    Jumpstart::Multitenancy.stub :selected, ["domain"] do
      get user_root_path
      assert_match I18n.t("shared.navbar.signed_in_as_html", user: @user.name), response.body

      host! @account.domain
      sign_in @user

      get user_root_path
      assert_match I18n.t("shared.navbar.signed_in_as_html", user: @account.name), response.body
    end
  end

  test "subdomain multitenancy" do
    Jumpstart::Multitenancy.stub :selected, ["subdomain"] do
      get user_root_path
      assert_match I18n.t("shared.navbar.signed_in_as_html", user: @user.name), response.body

      host! "#{@account.subdomain}.example.com"
      sign_in @user

      get user_root_path
      assert_match I18n.t("shared.navbar.signed_in_as_html", user: @account.name), response.body
    end
  end

  test "script path multitenancy" do
    Jumpstart::Multitenancy.stub :selected, ["path"] do
      get "/"
      assert_match I18n.t("shared.navbar.signed_in_as_html", user: @user.name), response.body

      get "/#{@account.id}/"
      assert_match I18n.t("shared.navbar.signed_in_as_html", user: @account.name), response.body
    end
  end

  test "session multitenancy" do
    Jumpstart::Multitenancy.stub :selected, [] do
      get user_root_path
      assert_match I18n.t("shared.navbar.signed_in_as_html", user: @user.name), response.body

      switch_account(@account)

      get user_root_path
      assert_match I18n.t("shared.navbar.signed_in_as_html", user: @account.name), response.body
    end
  end
end
