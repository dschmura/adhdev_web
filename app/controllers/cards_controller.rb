class CardsController < ApplicationController
  def edit; end

  def update
    current_team.update_card(token)
    redirect_to subscription_path, notice: "Your card was updated successfully."
  end

  private

  def card_params
    params.require(:team).permit(:card_token)
  end

  def token
    card_params.fetch('card_token')
  end
end
