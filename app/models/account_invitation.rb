class AccountInvitation < ApplicationRecord
  belongs_to :account
  belongs_to :invited_by, class_name: "User", optional: true
  has_secure_token

  validates :name, :email, presence: true
  validates :email, uniqueness: {scope: :account_id, message: "has already been invited"}

  # Store the roles in the roles json column and cast to booleans
  store_accessor :roles, *AccountUser::ROLES

  # Cast roles to/from booleans
  AccountUser::ROLES.each do |role|
    define_method(:"#{role}=") { |value| super ActiveRecord::Type::Boolean.new.cast(value) }
    define_method(:"#{role}?") { send(role) }
  end

  def save_and_send_invite
    if save
      AccountInvitationsMailer.with(account_invitation: self).invite.deliver_later
    end
  end

  def accept!(user)
    account_user = account.account_users.new(user: user, roles: roles)
    if account_user.valid?
      ApplicationRecord.transaction do
        account_user.save!
        destroy!
      end
      account_user
    else
      errors.add(:base, account_user.errors.full_messages.first)
      nil
    end
  end

  def reject!
    destroy
  end

  def to_param
    token
  end
end
