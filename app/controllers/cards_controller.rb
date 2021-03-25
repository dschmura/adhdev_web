class CardsController < ApplicationController
  before_action :authenticate_user!

  def edit
    if Jumpstart.config.stripe?
      @setup_intent = current_account.processor&.stripe? ? current_account.payment_processor.create_setup_intent : Stripe::SetupIntent.create
    end
  end

  def update
    current_account.assign_attributes(processor: processor)
    current_account.update_card(token)
    redirect_to subscription_path, notice: t(".updated")
  end

  private

  def card_params
    params.require(:account).permit(:card_token, :processor)
  end

  def token
    card_params.fetch("card_token")
  end

  def processor
    card_params.fetch("processor")
  end
end
