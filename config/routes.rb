 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :posts
  resources :tweets

  # Jumpstart views
  if Rails.env.development? || Rails.env.test?
    mount Jumpstart::Engine, at: '/jumpstart'
    mount LetterOpenerWeb::Engine, at: "/letter_opener"

    namespace :jumpstart do
      resource :docs do
        [:announcements, :billing, :scaffolds, :teams, :users].each{ |doc| get doc }
        [:alerts, :buttons, :cards, :forms, :icons, :javascript, :pagination, :pills, :typography, :wells].each{ |doc| get doc }
      end
    end
  end

  # Administrate
  authenticate :user, lambda { |u| u.admin? } do
    namespace :admin do
      if defined?(Sidekiq)
        require 'sidekiq/web'
        mount Sidekiq::Web => '/sidekiq'
      end

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

  # User account
  devise_for :users,
             controllers: {
               masquerades: 'jumpstart/masquerades',
               omniauth_callbacks: 'users/omniauth_callbacks',
               registrations: 'users/registrations',
             }

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

  resources :users
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
