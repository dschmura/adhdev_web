module UserAccounts
  extend ActiveSupport::Concern

  included do
    has_many :account_invitations, dependent: :nullify, foreign_key: :invited_by_id
    has_many :account_users, dependent: :destroy
    has_many :accounts, through: :account_users, dependent: :destroy
    has_many :owned_accounts, class_name: "Account", foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy
    has_one :personal_account, ->{ where(personal: true) }, class_name: "Account", foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy

    # Regular users should get their account created immediately
    after_create :create_personal_account
    after_update :update_personal_account
  end

  def create_personal_account
    # Invited users don't have a name immediately, so we will run this method twice for them
    # once on create where no name is present and again on accepting the invitation
    return unless name.present?
    return personal_account if personal_account.present?

    account = build_personal_account name: name, personal: true
    account.account_users.new(user: self, admin: true)
    account.save!
    account
  end

  def update_personal_account
    if first_name_previously_changed? || last_name_previously_changed?
      # Accepting an invitation calls this when the user's name is updated
      create_personal_account if personal_account.nil?

      # Sync the personal account name with the user's name
      personal_account.update(name: name)
    end
  end
end
