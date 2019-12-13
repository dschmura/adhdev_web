require 'test_helper'

class Jumpstart::TeamsTest < ActionDispatch::IntegrationTest
  setup do
    @team = teams(:company)
    @admin = users(:one)
    @regular_user = users(:two)
  end

  class AdminUsers < Jumpstart::TeamsTest
    setup do
      sign_in @admin
    end

    test "can edit team" do
      get edit_team_path(@team)
      assert_response :success
      assert_select "button", "Update Team"
    end

    test "can update team" do
      put team_path(@team), params: { team: { name: "Test Team 2" } }
      assert_redirected_to team_path(@team)
      follow_redirect!
      assert_select "h1", "Test Team 2"
    end

    test "can delete team" do
      assert_difference "Team.count", -1 do
        delete team_path(@team)
      end
      assert_redirected_to teams_path
    end
  end

  class RegularUsers < Jumpstart::TeamsTest
    setup do
      sign_in @regular_user
    end

    test "cannot edit team" do
      get edit_team_path(@team)
      assert_redirected_to team_path(@team)
    end

    test "cannot update team" do
      name = @team.name
      put team_path(@team), params: { team: { name: "Test Team Changed" } }
      assert_redirected_to team_path(@team)
      follow_redirect!
      assert_select "h1", name
    end

    test "cannot delete team" do
      assert_no_difference "Team.count" do
        delete team_path(@team)
      end
      assert_redirected_to team_path(@team)
    end
  end
end
