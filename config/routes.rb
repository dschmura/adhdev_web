# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  mount Jumpstart::Engine, at: '/jumpstart'

  devise_for :users,
             controllers: { omniauth_callbacks: 'jumpstart/omniauth_callbacks' }

  resource :card
  resource :subscription do
    patch :resume
  end

  scope controller: :static do
    get :about
    get :terms
    get :privacy
  end

  root to: "static#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
