class CardsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @setup_intent = current_team.create_setup_intent
  end

  def update
    current_team.assign_attributes(processor: processor)
    current_team.update_card(token)
    redirect_to subscription_path, notice: "Your card was updated successfully."
  end

  private

  def card_params
    params.require(:team).permit(:card_token, :processor)
  end

  def token
    card_params.fetch('card_token')
  end

  def processor
    card_params.fetch('processor')
  end
end
