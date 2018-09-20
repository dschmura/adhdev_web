class SubscriptionsController < ApplicationController
  before_action :require_user
  before_action :set_plan, only: [:new]
  before_action :set_subscription, only: [:edit, :update]

  def show
  end

  def new
  end

  def create
    # Get the Stripe or Braintree specific ID
    plan_id = Jumpstart.processor_plan_id_for(plan, processor)

    current_user.card_token = token
    current_user.subscribe('default', plan_id, processor)

    redirect_to root_path
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    render :new
  end

  def edit; end

  def update
    plan_id = Jumpstart.processor_plan_id_for(plan, @subscription.processor)
    @subscription.swap(plan_id)
    redirect_to subscription_path
  end

  def resume
    current_user.subscription.resume
    redirect_to subscription_path, notice: "Your subscription has been resumed."
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
