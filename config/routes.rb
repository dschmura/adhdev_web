require 'sidekiq/web'

Rails.application.routes.draw do
  resources :tweets

  # Jumpstart views
  if Rails.env.development?
    mount Jumpstart::Engine, at: '/jumpstart'
    namespace :docs do
      resource :javascript
    end
  end

  # Administrate
  authenticate :user, lambda { |u| u.admin? } do
    namespace :admin do
      mount Sidekiq::Web => '/sidekiq'

      resources :users
      resources :subscriptions
      resources :charges
      namespace :user do
        resources :connected_accounts
      end

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
    patch :info
    patch :resume
  end
  resources :charges

  namespace :user, module: :users do
    resources :connected_accounts
  end

  scope controller: :static do
    get :about
    get :terms
    get :privacy
    get :pricing
  end

  root to: "static#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
