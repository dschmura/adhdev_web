require 'test_helper'

begin
  require 'stripe_mock'
rescue LoadError
end

class SubscriptionsTest < ActionDispatch::IntegrationTest
  setup do
    StripeMock.start
  end

  teardown do
    StripeMock.stop
  end

  def stripe_helper
    @stripe_helper ||= StripeMock.create_test_helper
  end

  if defined?(StripeMock)
    test "can subscribe personal team to a plan" do
      user = users(:one)
      team = user.personal_team
      sign_in user
      switch_team team

      plan = plans(:personal)
      card_token = StripeMock.generate_card_token
      stripe_helper.create_plan(id: plan.stripe_id, amount: plan.amount)

      post "/subscription", params: { team: { card_token: card_token, plan: plan.id, processor: "stripe" } }
      assert_response :redirect
      follow_redirect!
      assert_response :success
      assert user.personal_team.subscribed?
    end

    test "can subscribe a team to a plan" do
      user = users(:one)
      team = teams(:company)
      sign_in user
      switch_team team

      plan = plans(:personal)
      card_token = StripeMock.generate_card_token
      stripe_helper.create_plan(id: plan.stripe_id, amount: plan.amount)

      post "/subscription", params: { team: { card_token: card_token, plan: plan.id, processor: "stripe" } }
      assert_response :redirect
      follow_redirect!
      assert_response :success
      assert team.subscribed?
    end
  end
end
