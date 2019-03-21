require 'test_helper'

class TeamMemberTest < ActiveSupport::TestCase
  test "converts roles to booleans" do
    member = TeamMember.new admin: "1"
    assert_equal true, member.admin
  end
end

