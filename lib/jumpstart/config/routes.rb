Rails.application.routes.draw do
  namespace :jumpstart do
    resource :admin, only: [:show]
    resource :config, only: [:create]

    resource :docs do
      [:announcements, :billing, :scaffolds, :teams, :users].each{ |doc| get doc }
      [:alerts, :buttons, :cards, :forms, :icons, :javascript, :pagination, :pills, :typography, :wells].each{ |doc| get doc }
    end

    root to: "admin#show"
  end
end
