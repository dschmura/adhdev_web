 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do

  # Jumpstart views
  if Rails.env.development?
    mount Jumpstart::Engine, at: '/jumpstart'
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
    resource :docs
    namespace :docs do
      resource :alert
      resource :button
      resource :card
      resource :form
      resource :icon
      resource :javascript
      resource :pagination
      resource :pill
      resource :typography
      resource :well
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
      namespace :pay do
        resources :charges
        resources :subscriptions
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
