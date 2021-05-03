require "test_helper"

class PaymentMethodsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "user can add a card without a processor set" do
    sign_in @user
    @user.personal_account.update(processor: nil)

    switch_account @user.personal_account
    get edit_card_path
    assert_response :success
  end
end
