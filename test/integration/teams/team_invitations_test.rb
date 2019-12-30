require 'test_helper'

class Jumpstart::TeamsTeamInvitationsTest < ActionDispatch::IntegrationTest
  setup do
    @team = teams(:company)
    @admin = users(:one)
    @regular_user = users(:two)
  end

  class AdminUsers < Jumpstart::TeamsTeamInvitationsTest
    setup do
      sign_in @admin
    end

    test "can view invite form" do
      get new_team_team_invitation_path(@team)
      assert_response :success
    end

    test "can invite team members" do
      name, email = "Team Member", "new-member@example.com"
      assert_difference "@team.team_invitations.count" do
        post team_team_invitations_path(@team), params: { team_invitation: { name: name, email: email, admin: "0" } }
      end
      assert_not @team.team_invitations.last.admin?
    end

    test "can invite team members with roles" do
      name, email = "Team Member", "new-member@example.com"
      assert_difference "@team.team_invitations.count" do
        post team_team_invitations_path(@team), params: { team_invitation: { name: name, email: email, admin: "1" } }
      end
      assert @team.team_invitations.last.admin?
    end

    test "can cancel invitation" do
      assert_difference "@team.team_invitations.count", -1 do
        delete team_team_invitation_path(@team, @team.team_invitations.last)
      end
    end
  end

  class RegularUsers < Jumpstart::TeamsTeamInvitationsTest
    setup do
      sign_in @regular_user
    end

    test "cannot view invite form" do
      get new_team_team_invitation_path(@team)
      assert_response :redirect
    end

    test "cannot invite team members" do
      assert_no_difference "@team.team_invitations.count" do
        post team_team_invitations_path(@team), params: { team_invitation: { name: "test", email: "new-member@example.com", admin: "0" } }
      end
    end

    test "can cancel invitation" do
      assert_no_difference "@team.team_invitations.count" do
        delete team_team_invitation_path(@team, @team.team_invitations.last)
      end
    end
  end
end
