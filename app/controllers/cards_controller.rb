class CardsController < ApplicationController
  def edit; end

  def update
    current_team.assign_attributes(processor: processor)
    current_team.update_card(token)
    redirect_back fallback_location: subscription_path, notice: "Your card was updated successfully."
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
