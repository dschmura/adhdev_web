class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_team, :require_payments_enabled
  before_action :set_plan, only: [:new]
  before_action :set_subscription, only: [:edit, :update]

  def show
  end

  def new
    if Jumpstart.config.stripe? && @plan.trial_period_days.to_i > 0
      @setup_intent = current_team.create_setup_intent
    end
  end

  def create
    current_team.assign_attributes(subscription_params)
    @plan = Plan.find(current_team.plan) # Get the Stripe or Braintree specific ID
    processor_id = @plan.processor_id(current_team.processor)
    current_team.subscribe(plan: processor_id)
    redirect_to root_path, notice: "Thanks for subscribing!"

  rescue Pay::ActionRequired => e
    redirect_to pay.payment_path(e.payment.id)

  rescue Pay::Error => e
    flash[:alert] = e.message
    render :new
  end

  def edit; end

  def update
    current_team.assign_attributes(subscription_params)

    # Get the Stripe or Braintree specific ID
    @plan = Plan.find(current_team.plan)
    processor_id = @plan.processor_id(current_team.processor)

    @subscription.swap(processor_id)
    redirect_to subscription_path
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :edit
  end

  def resume
    current_team.subscription.resume
    redirect_to subscription_path, notice: "Your subscription has been resumed."
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :show
  end

  def destroy
    current_team.subscription.cancel

    # Optionally, you can cancel immediately
    # current_team.subscription.cancel_now!

    redirect_to subscription_path
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :show
  end

  def info
    current_team.update(subscription_params)
    redirect_to subscription_path, notice: "Extra billing info saved sucessfully."
  end

  private

  def subscription_params
    params.require(:team).permit(:card_token, :plan, :processor, :extra_billing_info)
  end

  def require_team
    redirect_to new_user_registration_path unless current_team
  end

  def require_payments_enabled
    return if Jumpstart.config.payments_enabled?
    flash[:alert] = "Jumpstart must be configured for payments before you can manage subscriptions."
    redirect_back(fallback_location: root_path)
  end

  def set_plan
    @plan = Plan.find_by(id: params[:plan])
    redirect_to pricing_path if @plan.nil?
  end

  def set_subscription
    @subscription = current_team.subscription
    redirect_to subscription_path if @subscription.nil?
  end
end
