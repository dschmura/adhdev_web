class SubscriptionsController < ApplicationController
  before_action :require_user
  before_action :set_plan, only: [:new]
  before_action :set_subscription, only: [:edit, :update]

  def show
  end

  def new
  end

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
    @subscription.swap(plan)
    redirect_to subscription_path
  end

  def resume
    current_user.subscription.resume
    flash[:notice] = 'Subscription Resumed'
    redirect_to subscription_path
  end

  def destroy
    if Jumpstart.config.cancel_immediately?
      current_user.subscription.cancel_now!
    else
      current_user.subscription.cancel
    end

    redirect_to subscription_path
  end

  def info
    current_user.update(subscription_params)
    redirect_to subscription_path, notice: "Extra billing info saved sucessfully."
  end

  private

  def plan
    subscription_params.fetch('plan')
  end

  def processor
    subscription_params.fetch('processor')
  end

  def subscription_params
    params.require(:user).permit(:card_token, :plan, :processor, :extra_billing_info)
  end

  def token
    subscription_params.fetch('card_token')
  end

  def require_user
    redirect_to new_user_registration_path unless user_signed_in?
  end

  def set_plan
    @plan = Jumpstart.find_plan(params[:plan])
    redirect_to pricing_path if @plan.nil?
  end

  def set_subscription
    @subscription = current_user.subscription
  end
end
