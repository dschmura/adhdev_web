require 'test_helper'

class Jumpstart::TeamMembersTest < ActionDispatch::IntegrationTest
  setup do
    @team = teams(:company)
    @admin = users(:one)
    @regular_user = users(:two)
  end

  class AdminUsers < Jumpstart::TeamMembersTest
    setup do
      sign_in @admin
    end

    test "can view team members" do
      get team_path(@team)
      assert_select "h1", @team.name
      assert_select "a", text: "Edit Team", count: 1
      assert_select "a", text: "Edit", count: @team.team_members.count
      assert_select "a", text: "Invite A Team Member", count: 1
    end

    test "can view new team member form" do
      get new_team_team_member_path(@team)
      assert_select "button", "Send invitation"
    end

    test "can add team members" do
      name, email = "Team Member", "new-member@example.com"
      assert_difference "@team.team_members.count" do
        post team_team_members_path(@team), params: { name: name, email: email }
      end
      assert_includes @team.users, User.find_by(email: email)
      assert_response :redirect
    end

    test "can edit team member" do
      team_member = team_members(:company_regular_user)
      get edit_team_team_member_path(@team, team_member)
      assert_select "button", "Update Team member"
    end

    test "can update team member" do
      team_member = team_members(:company_regular_user)
      put team_team_member_path(@team, team_member), params: { team_member: { admin: "1" }}
      assert_response :redirect
      assert team_member.reload.admin?
    end

    test "can delete team members" do
      user = users(:two)
      member = @team.team_members.find_by(user: user)
      assert_difference "@team.team_members.count", -1 do
        delete team_team_member_path(@team, member.id)
      end
      assert_response :redirect
    end
  end

  class RegularUsers < Jumpstart::TeamMembersTest
    setup do
      sign_in @regular_user
    end

    test "can view team members but not edit" do
      get team_path(@team)
      assert_select "h1", @team.name

      assert_select "a", text: "Edit Team", count: 0
      assert_select "a", text: "Edit", count: 0
      assert_select "a", text: "Invite A Team Member", count: 0
    end

    test "can view new team member form" do
      get new_team_team_member_path(@team)
      assert_redirected_to team_path(@team)
    end

    test 'Regular user cannot view team member page' do
      get team_team_member_path(@team, @admin)
      assert_redirected_to team_path(@team)
    end

    test 'Regular user cannot add team members' do
      name, email = "Team Member", "new-member@example.com"
      post team_team_members_path(@team), params: { name: name, email: email }
      assert_redirected_to team_path(@team)
    end

    test 'Regular user cannot edit team members' do
      # Cannot edit themselves
      team_member = @team.team_members.find_by(user: @regular_user)
      get edit_team_team_member_path(@team, team_member)
      assert_redirected_to team_path(@team)

      # Cannot edit admin user
      team_member = @team.team_members.find_by(user: @admin)
      get edit_team_team_member_path(@team, team_member)
      assert_redirected_to team_path(@team)
    end

    test 'Regular user cannot update team members' do
      # Cannot edit themselves
      team_member = @team.team_members.find_by(user: @regular_user)
      put team_team_member_path(@team, team_member), params: { admin: "1" }
      assert_redirected_to team_path(@team)

      # Cannot edit admin user
      team_member = @team.team_members.find_by(user: @admin)
      put team_team_member_path(@team, team_member), params: { admin: "0" }
      assert_redirected_to team_path(@team)
    end

    test "Regular user cannot delete team members" do
      user = users(:one)
      member = @team.team_members.find_by(user: user)
      delete team_team_member_path(@team, member.id)
      assert_redirected_to team_path(@team)
      assert_includes @team.team_members.pluck(:user_id), user.id
    end
  end
end
