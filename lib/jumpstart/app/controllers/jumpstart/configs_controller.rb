require_dependency "jumpstart/application_controller"

module Jumpstart
  class ConfigsController < ApplicationController
    def create
      Jumpstart::Configuration.new(config_params).save

      # Install the new gem dependencies
      Jumpstart.bundle
      Jumpstart.run_command("solargraph bundle") if Jumpstart.config.solargraph?
      Jumpstart.restart

      redirect_to root_path(reload: true), notice: "Your app is restarting with the new configuration..."
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
          :solargraph,
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
