class CardsController < ApplicationController
  def edit; end

  def update
    current_user.update_card(token)
    flash[:notice] = 'Card Updated'
    redirect_to edit_card_path
  end

  private

  def card_params
    params.require(:user).permit(:card_token)
  end

  def token
    card_params.fetch('card_token')
  end
end
