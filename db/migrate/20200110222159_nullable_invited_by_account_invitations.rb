class NullableInvitedByAccountInvitations < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      change_column_null :account_invitations, :invited_by_id, true
    end
  end
end
