class SubscriptionsController < ApplicationController
  before_action :require_payments_enabled
  before_action :authenticate_user_with_sign_up!
  before_action :require_account
  before_action :require_current_account_admin, except: [:show]
  before_action :set_plan, only: [:new]
  before_action :set_subscription, only: [:edit, :update]

  def show
  end

  def new
    if Jumpstart.config.stripe? && @plan.trial_period_days.to_i > 0
      @setup_intent = current_account.processor&.stripe? ? current_account.payment_processor.create_setup_intent : Stripe::SetupIntent.create
    end
  end

  def create
    current_account.assign_attributes(subscription_params)
    @plan = Plan.without_free.find(current_account.plan) # Get the Stripe or Braintree specific ID
    processor_id = @plan.processor_id(current_account.processor)
    current_account.subscribe(plan: processor_id, trial_period_days: @plan.trial_period_days)
    redirect_to root_path, notice: t(".created")
  rescue Pay::ActionRequired => e
    redirect_to pay.payment_path(e.payment.id)
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    current_account.assign_attributes(subscription_params)

    # Get the Stripe or Braintree specific ID
    @plan = Plan.find(current_account.plan)
    processor_id = @plan.processor_id(current_account.processor)

    @subscription.swap(processor_id)
    redirect_to subscription_path
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :edit, status: :unprocessable_entity
  end

  def resume
    current_account.subscription.resume
    redirect_to subscription_path, notice: t(".resumed")
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :show, status: :unprocessable_entity
  end

  def pause
    current_account.subscription.pause
    redirect_to subscription_path
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :show
  end

  def destroy
    current_account.subscription.cancel

    current_account.update(card_type: nil, card_last4: nil, card_exp_month: nil, card_exp_year: nil) if current_account.subscription.paddle?

    # Optionally, you can cancel immediately
    # current_account.subscription.cancel_now!

    redirect_to subscription_path
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :show, status: :unprocessable_entity
  end

  def info
    current_account.update(subscription_params)
    redirect_to subscription_path, notice: t(".info_updated")
  end

  private

  def subscription_params
    params.require(:account).permit(:card_token, :plan, :processor, :extra_billing_info)
  end

  def require_account
    redirect_to new_user_registration_path unless current_account
  end

  def require_payments_enabled
    return if Jumpstart.config.payments_enabled?
    flash[:alert] = "Jumpstart must be configured for payments before you can manage subscriptions."
    redirect_back(fallback_location: root_path)
  end

  def set_plan
    @plan = Plan.without_free.find(params[:plan])
  rescue ActiveRecord::RecordNotFound
    redirect_to pricing_path
  end

  def set_subscription
    @subscription = current_account.subscription
    redirect_to subscription_path if @subscription.nil?
  end
end
