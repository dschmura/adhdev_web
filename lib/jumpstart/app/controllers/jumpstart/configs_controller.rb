require_dependency "jumpstart/application_controller"

module Jumpstart
  class ConfigsController < ApplicationController
    def create
      Jumpstart::Configuration.new(config_params).save
      Jumpstart.restart

      redirect_to main_app.root_path, notice: "Jumpstart configuration updated successfully."
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
              omniauth_providers: [],
              plans: [:id, :name, features: [], month: [:amount, :stripe_id, :braintree_id], year: [:amount, :stripe_id, :braintree_id]]
            )
            .merge(payment_processors)
    end

    def payment_processors
      processors = params.require(:configuration).permit(payment_processors: {})
      processors = processors.fetch('payment_processors', {})
      { payment_processors: processors.keys.map(&:to_sym) }
    end
  end
end
