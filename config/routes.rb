require 'sidekiq/web'
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :tweets

  # Jumpstart views
  mount Jumpstart::Engine, at: '/jumpstart'

  # Administrate
  authenticate :user, lambda { |u| u.admin? } do
    namespace :admin do
      mount Sidekiq::Web => '/sidekiq'

      resources :users
      resources :subscriptions
      resources :charges
      resources :connected_accounts

      root to: "users#index"
    end
  end

  # User account
  devise_for :users,
             controllers: {
               masquerades: 'jumpstart/masquerades',
               omniauth_callbacks: 'users/omniauth_callbacks',
               registrations: 'users/registrations',
             }

  scope module: :users do
    resource :password
  end

  # Payments
  resource :card
  resource :subscription do
    patch :resume
  end

  namespace :user, module: :users do
    resources :connected_accounts
  end

  scope controller: :static do
    get :about
    get :terms
    get :privacy
  end

  root to: "static#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
