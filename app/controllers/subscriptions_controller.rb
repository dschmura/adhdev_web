class SubscriptionsController < ApplicationController
  before_action :require_user
  before_action :set_plan, only: [:new]
  before_action :set_subscription, only: [:edit, :update]

  def show
  end

  def new
  end

  def create
    current_user.assign_attributes(subscription_params)

    # Get the Stripe or Braintree specific ID
    @plan = Plan.find(current_user.plan)
    plan_id = @plan.plan_id_for_processor(current_user.processor)

    current_user.subscribe(plan: plan_id)

    redirect_to root_path
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :new
  end

  def edit; end

  def update
    current_user.assign_attributes(subscription_params)

    # Get the Stripe or Braintree specific ID
    @plan = Plan.find(current_user.plan)
    plan_id = @plan.plan_id_for_processor(current_user.processor)

    @subscription.swap(plan_id)
    redirect_to subscription_path
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :edit
  end

  def resume
    current_user.subscription.resume
    redirect_to subscription_path, notice: "Your subscription has been resumed."
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :show
  end

  def destroy
    if Jumpstart.config.cancel_immediately?
      current_user.subscription.cancel_now!
    else
      current_user.subscription.cancel
    end

    redirect_to subscription_path
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :show
  end

  def info
    current_user.update(subscription_params)
    redirect_to subscription_path, notice: "Extra billing info saved sucessfully."
  end

  private

  def subscription_params
    params.require(:user).permit(:card_token, :plan, :processor, :extra_billing_info)
  end

  def require_user
    redirect_to new_user_registration_path unless user_signed_in?
  end

  def set_plan
    @plan = Plan.find_by(id: params[:plan])
    redirect_to pricing_path if @plan.nil?
  end

  def set_subscription
    @subscription = current_user.subscription
  end
end
