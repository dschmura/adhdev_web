class CardsController < ApplicationController
  def edit; end

  def update
    current_user.update_card(token)
    redirect_to subscription_path, notice: "Your card was updated successfully."
  end

  private

  def card_params
    params.require(:user).permit(:card_token)
  end

  def token
    card_params.fetch('card_token')
  end
end
