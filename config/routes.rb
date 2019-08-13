 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do

  # Jumpstart views
  if Rails.env.development? || Rails.env.test?
    mount Jumpstart::Engine, at: '/jumpstart'
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Administrate
  authenticated :user, lambda { |u| u.admin? } do
    namespace :admin do
      if defined?(Sidekiq)
        require 'sidekiq/web'
        mount Sidekiq::Web => '/sidekiq'
      end

      resources :announcements
      resources :users
      namespace :user do
        resources :connected_accounts
      end
      resources :teams
      resources :team_members
      resources :plans
      namespace :pay do
        resources :charges
        resources :subscriptions
      end

      root to: "dashboard#show"
    end
  end

  # API routes
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resource :me, controller: :me
      resources :teams
    end
  end

  # User account
  devise_for :users,
             controllers: {
               masquerades: 'jumpstart/masquerades',
               omniauth_callbacks: 'users/omniauth_callbacks',
               registrations: 'users/registrations',
             }

  resources :announcements, only: [:index]
  resources :api_tokens
  resources :teams do
    member do
      patch :switch
    end

    resources :team_members, path: :members
  end

  # Payments
  resource :card
  resource :subscription do
    patch :info
    patch :resume
  end
  resources :charges
  namespace :account do
    resource :password
  end

  namespace :users do
    resources :mentions, only: [:index]
  end
  namespace :user, module: :users do
    resources :connected_accounts
  end

  scope controller: :static do
    get :about
    get :terms
    get :privacy
    get :pricing
  end

  authenticated :user do
    root to: "dashboard#show", as: :user_root
  end

  # Public marketing homepage
  root to: "static#index"
end
