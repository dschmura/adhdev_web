require "test_helper"

class PaymentMethodsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "user can add a payment method without a processor set" do
    sign_in @user
    @user.personal_account.pay_customers.destroy_all

    switch_account @user.personal_account
    get new_payment_method_path
    assert_response :success
  end
end
