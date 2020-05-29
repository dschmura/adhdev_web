require_dependency "jumpstart/application_controller"

module Jumpstart
  class ConfigsController < ApplicationController
    def create
      Jumpstart::Configuration.new(config_params).save

      # Install the new gem dependencies
      Jumpstart.bundle
      Jumpstart.restart

      respond_to do |format|
        format.html { redirect_to root_path, notice: "Restart your Rails app to load the new Jumpstart configuration." }
        format.js
      end
    end

    private

    def config_params
      params.require(:configuration)
        .permit(
          :application_name,
          :business_name,
          :business_address,
          :domain,
          :default_from_email,
          :support_email,
          :background_job_processor,
          :cancel_immediately,
          :email_provider,
          :personal_accounts,
          :livereload,
          :register_with_account,
          integrations: [],
          omniauth_providers: [],
          payment_processors: [],
          multitenancy: [],
          plans: [:id, :name, features: [], month: [:amount, :stripe_id, :braintree_id], year: [:amount, :stripe_id, :braintree_id]]
        )
    end
  end
end
