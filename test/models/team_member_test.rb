# == Schema Information
#
# Table name: team_members
#
#  id         :bigint(8)        not null, primary key
#  roles      :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_team_members_on_team_id  (team_id)
#  index_team_members_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class TeamMemberTest < ActiveSupport::TestCase
  test "converts roles to booleans" do
    member = TeamMember.new admin: "1"
    assert_equal true, member.admin
  end

  test "can be assigned a role" do
    member = TeamMember.new admin: "1"
    assert_equal true, member.admin
    assert_equal true, member.admin?
  end
end

