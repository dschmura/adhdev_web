class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def new; end

  def create
    current_user.card_token = token
    current_user.subscribe(plan, plan, processor)
    redirect_to root_path
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    render :new
  end

  def edit; end

  def update
    current_user.subscription.swap(plan)
    redirect_to edit_subscription_path
  end

  def resume
    current_user.subscription.resume
    flash[:notice] = 'Subscription Resumed'
    redirect_to edit_subscription_path
  end

  def destroy
    if Jumpstart.config.cancel_immediately?
      current_user.subscription.cancel_now!
    else
      current_user.subscription.cancel
    end

    redirect_to edit_subscription_path
  end

  private

  def plan
    subscription_params.fetch('plan')
  end

  def processor
    subscription_params.fetch('processor')
  end

  def subscription_params
    params.require(:user).permit(:card_token, :plan, :processor)
  end

  def token
    subscription_params.fetch('card_token')
  end
end
