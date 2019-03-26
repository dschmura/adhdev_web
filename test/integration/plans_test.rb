require 'test_helper'

class Jumpstart::PlansTest < ActionDispatch::IntegrationTest
  test "can register and login with a social account" do
    get "/pricing"

    Plan.find_each do |plan|
      assert response.body.include?(plan.name)
    end
  end

  test "can view subscribe page for a plan" do
    sign_in users(:one)
    plan = plans(:personal)

    get "/subscription/new?plan=#{plan.id}"

    assert response.body.include?(plan.name)
    plan.features.each do |feature|
      assert response.body.include?(feature)
    end
  end

  test "can view subscribe page for a team plan" do
    team = teams(:company)
    user = team.owner
    plan = plans(:personal)

    sign_in user
    get "/subscription/new?plan=#{plan.id}"

    assert response.body.include?(team.name)
    assert response.body.include?(plan.name)
    plan.features.each do |feature|
      assert response.body.include?(feature)
    end
  end
end
