Rails.application.routes.draw do
  namespace :jumpstart do
    resource :admin, only: [:show]
    resource :config, only: [:create]

    root to: "admin#show"
  end
end
