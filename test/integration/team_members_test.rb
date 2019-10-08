require 'test_helper'

class Jumpstart::TeamMembersTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @team = teams(:company)
    sign_in @user
  end

  test "can view team members" do
    get team_path(@team)
    assert_select "h1", @team.name
    assert_select "a", @user.name
  end

  test "can add team members" do
    name, email = "Team Member", "new-member@example.com"
    post team_team_members_path(@team), params: { name: name, email: email }
    assert_response :redirect
    assert_equal 1, @team.team_members.joins(:user).where(users: { email: email }).count
    follow_redirect!
    assert_select "a", name
  end

  test "can delete team members" do
    user = users(:two)
    member = @team.team_members.find_by(user: user)
    delete team_team_member_path(@team, member.id)
    assert_response :redirect
    assert_not_includes @team.team_members.pluck(:user_id), user.id
  end
end
