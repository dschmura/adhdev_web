class AccountInvitationsController < ApplicationController
  before_action :set_account_invitation
  before_action :authenticate_user_with_sign_up!

  def show
    @account = @account_invitation.account
    @invited_by = @account_invitation.invited_by
  end

  def update
    if @account_invitation.accept!(current_user)
      redirect_to accounts_path
    else
      message = @account_invitation.errors.full_messages.first || "Something went wrong"
      redirect_to account_invitation_path(@account_invitation), alert: message
    end
  end

  def destroy
    @account_invitation.reject!
    redirect_to root_path
  end

  private

  def set_account_invitation
    @account_invitation = AccountInvitation.find_by!(token: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Whoops, we weren't able to find this invitation. Check with your account admin for a new invitation."
  end
end
