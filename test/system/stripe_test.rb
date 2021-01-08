# Don't run these tests if Stripe is disabled
return unless defined?(Stripe)

require "application_system_test_case"

class StripeTest < ApplicationSystemTestCase
  setup do
    @user = users(:two)
    @account = @user.personal_account
    login_as @user, scope: :user
    switch_account(@account)
  end

  test "can subscribe" do
    visit new_subscription_url(plan: plans(:personal))
    fill_stripe_elements card: "4242 4242 4242 4242"
    fill_in "Name on Card", with: @user.name
    click_on "Subscribe"
    assert_selector "p", text: "Thanks for subscribing!"
    assert @account.subscribed?
  end

  test "can subscribe with SCA" do
    visit new_subscription_url(plan: plans(:personal))
    fill_stripe_elements(card: "4000 0027 6000 3184")
    fill_in "Name on Card", with: @user.name
    click_on "Subscribe"
    assert_selector "h1", text: "Confirm your $19.00 payment"
    complete_stripe_sca
    assert_selector "p", text: "The payment was successful."
    # Webhook will update the subscription to active, so we can't easily test that here
  end

  test "handles SCA and insufficient funds" do
    visit new_subscription_url(plan: plans(:personal))
    fill_stripe_elements(card: "4000 0082 6000 3178")
    fill_in "Name on Card", with: @user.name
    click_on "Subscribe"
    # assert_selector "h1", text: "Confirm your $19.00 payment"
    complete_stripe_sca
    assert_selector "span", text: "Your card has insufficient funds."
    # Webhook will update the subscription to active, so we can't easily test that here
  end

  test "fail subscribe with SCA" do
    visit new_subscription_url(plan: plans(:personal))
    fill_stripe_elements(card: "4000 0027 6000 3184")
    fill_in "Name on Card", with: @user.name
    click_on "Subscribe"
    assert_selector "h1", text: "Confirm your $19.00 payment"
    fail_stripe_sca
    assert_selector "p", text: "We are unable to authenticate your payment method. Please choose a different payment method and try again."
  end

  test "can update card" do
    visit edit_card_url
    fill_stripe_elements(card: "4242 4242 4242 4242")
    fill_in "Name on Card", with: @user.name
    click_on "Update Card"
    assert_selector "p", text: "Your card was updated successfully."
    assert_equal "4242", @account.reload.card_last4
  end

  test "can update card with SCA" do
    visit edit_card_url
    fill_stripe_elements(card: "4000 0027 6000 3184")
    fill_in "Name on Card", with: @user.name
    click_on "Update Card"
    complete_stripe_sca
    assert_selector "p", text: "Your card was updated successfully."
    assert_equal "3184", @account.reload.card_last4
  end

  test "can fail updating card with SCA" do
    visit edit_card_url
    fill_stripe_elements(card: "4000 0027 6000 3184")
    fill_in "Name on Card", with: @user.name
    click_on "Update Card"
    fail_stripe_sca
    assert_selector "div", text: "We are unable to authenticate your payment method. Please choose a different payment method and try again."
    assert_nil @account.reload.card_last4
  end

  test "can swap plans" do
    old_plan_id = plans(:personal).processor_id(:stripe)

    @account.processor = :stripe
    @account.card_token = payment_method.id
    @account.subscribe(plan: old_plan_id)

    # Swap subscription
    visit edit_subscription_url
    click_on "Change Plan", match: :first

    # Assert we were redirected to the correct page
    assert_selector "h1", text: "Billing"
    assert_not_equal old_plan_id, @account.subscription.processor_plan
  end

  test "can swap plans with SCA" do
    # Subscribe to a new plan
    visit new_subscription_url(plan: plans(:personal))
    fill_stripe_elements(card: "4000 0027 6000 3184")
    fill_in "Name on Card", with: @user.name
    click_on "Subscribe"
    assert_selector "h1", text: "Confirm your $19.00 payment"
    complete_stripe_sca
    assert_selector "p", text: "The payment was successful."

    # Fake webhook that sets subscription status to active
    @account.subscription.update(status: :active)

    old_plan_id = @account.subscription.processor_plan

    # Swap subscription
    visit edit_subscription_url
    click_on "Change Plan", match: :first

    # Changes are prorated so we don't have to go through SCA again

    assert_selector "h1", text: "Billing"
    assert_not_equal old_plan_id, @account.subscription.processor_plan
  end

  # Subscribe with no trial
  # Redirect to payment auth page
  # Fail authentication
  # Verify that requires_payment_method on payment intent at this point
  # Then enter new card and authenticate
  # Then confirm subscribed

  private

  def payment_method
    @payment_method ||= create_payment_method
  end

  def sca_payment_method
    @sca_payment_method ||= create_payment_method(card: {number: "4000 0027 6000 3184"})
  end

  def create_payment_method(options = {})
    defaults = {
      type: "card",
      billing_details: {name: "Jane Doe"},
      card: {
        number: "4242 4242 4242 4242",
        exp_month: 9,
        exp_year: Time.now.year + 5,
        cvc: 123
      }
    }

    ::Stripe::PaymentMethod.create(defaults.deep_merge(options))
  end
end
