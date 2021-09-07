class SubscriptionsController < ApplicationController
  before_action :require_payments_enabled
  before_action :authenticate_user_with_sign_up!
  before_action :require_account
  before_action :require_current_account_admin, except: [:show]
  before_action :set_plan, only: [:new, :create, :update]
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]

  layout "checkout", only: [:new, :create]

  def index
    @payment_processor = current_account.payment_processor
    @subscriptions = current_account.subscriptions.active.order(created_at: :asc)
  end

  def show
    redirect_to edit_subscription_path(@subscription)
  end

  def new
    if Jumpstart.config.stripe? && @plan.has_trial?
      @setup_intent = current_account.payment_processor&.stripe? ? current_account.payment_processor.create_setup_intent : Stripe::SetupIntent.create
    end
  end

  def create
    payment_processor = params[:processor] ? current_account.set_payment_processor(params[:processor]) : current_account.payment_processor
    payment_processor.payment_method_token = params[:payment_method_token]
    payment_processor.subscribe(
      plan: @plan.id_for_processor(payment_processor.processor),
      trial_period_days: @plan.trial_period_days
    )
    redirect_to root_path, notice: t(".created")
  rescue Pay::ActionRequired => e
    redirect_to pay.payment_path(e.payment.id)
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  def edit
    # Include current plan even if hidden
    @current_plan = @subscription.plan

    plans = Plan.visible.sorted.or(Plan.where(id: @current_plan.id))
    @monthly_plans = plans.select(&:monthly?)
    @yearly_plans = plans.select(&:yearly?)
  end

  def update
    @subscription.swap @plan.id_for_processor(current_account.payment_processor.processor)
    redirect_to subscriptions_path, notice: t(".success")
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :edit, status: :unprocessable_entity
  end

  def resume
    current_account.payment_processor.subscription.resume
    redirect_to subscriptions_path, notice: t(".resumed")
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :show, status: :unprocessable_entity
  end

  def pause
    current_account.payment_processor.subscription.pause
    redirect_to subscriptions_path
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :show
  end

  def destroy
    @subscription.cancel

    # Optionally, you can cancel immediately
    # @subscription.cancel_now!

    redirect_to subscriptions_path
  rescue Pay::Error => e
    flash[:alert] = e.message
    render :show, status: :unprocessable_entity
  end

  def info
    current_account.update(info_params)
    redirect_to subscriptions_path, notice: t(".info_updated")
  end

  private

  def info_params
    params.require(:account).permit(:extra_billing_info)
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
    @subscription = current_account.subscriptions.find_by_prefix_id(params[:id])
    redirect_to subscriptions_path if @subscription.nil?
  end
end
