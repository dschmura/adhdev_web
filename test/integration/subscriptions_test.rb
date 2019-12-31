require 'test_helper'

class Jumpstart::SubscriptionsTest < ActionDispatch::IntegrationTest
  setup do
    @team = teams(:company)
    @admin = users(:one)
    @regular_user = users(:two)
    @plan = plans(:personal)
    @card_token = "tok_visa"
    switch_team(@team)
  end

  class AdminUsers < Jumpstart::SubscriptionsTest
    setup do
      sign_in @admin
    end

    test "can subscribe team" do
      Jumpstart.config.stub(:payments_enabled?, true) do
        get new_subscription_path(@plan.id)
        assert_redirected_to pricing_path
      end
    end
  end

  class RegularUsers < Jumpstart::SubscriptionsTest
    setup do
      sign_in @regular_user
    end

    test "cannot navigate to new_subscription page" do
      Jumpstart.config.stub(:payments_enabled?, true) do
        get new_subscription_path(plan: @plan.id)
        assert_redirected_to root_path
        assert_equal "You must be an admin to do that.", flash[:alert]
      end
    end

    test 'cannot subscribe' do
      Jumpstart.config.stub(:payments_enabled?, true) do
        post subscription_path, params: {}
        assert_redirected_to root_path
        assert_equal "You must be an admin to do that.", flash[:alert]
      end
    end

    test 'cannot delete subscription' do
      Jumpstart.config.stub(:payments_enabled?, true) do
        delete subscription_path
        assert_redirected_to root_path
        assert_equal "You must be an admin to do that.", flash[:alert]
      end
    end
  end
end
