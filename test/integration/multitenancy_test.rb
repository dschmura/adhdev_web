require "test_helper"

class Jumpstart::MultitenancyTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @account = accounts(:company)
    sign_in @user
  end

  test "domain multitenancy" do
    Jumpstart::Multitenancy.stub :selected, ["domain"] do
      get root_path
      assert_match "Signed in as <strong>#{@user.name}</strong>", response.body

      host! @account.domain
      sign_in @user

      get root_path
      assert_match "Signed in as <strong>#{@account.name}</strong>", response.body
    end
  end

  test "subdomain multitenancy" do
    Jumpstart::Multitenancy.stub :selected, ["subdomain"] do
      get root_path
      assert_match "Signed in as <strong>#{@user.name}</strong>", response.body

      host! "#{@account.subdomain}.example.com"
      sign_in @user

      get root_path
      assert_match "Signed in as <strong>#{@account.name}</strong>", response.body
    end
  end

  test "script path multitenancy" do
    Jumpstart::Multitenancy.stub :selected, ["path"] do
      get "/"
      assert_match "Signed in as <strong>#{@user.name}</strong>", response.body

      get "/#{@account.id}/"
      assert_match "Signed in as <strong>#{@account.name}</strong>", response.body
    end
  end

  test "session multitenancy" do
    Jumpstart::Multitenancy.stub :selected, [] do
      get root_path
      assert_match "Signed in as <strong>#{@user.name}</strong>", response.body

      switch_account(@account)

      get root_path
      assert_match "Signed in as <strong>#{@account.name}</strong>", response.body
    end
  end
end
