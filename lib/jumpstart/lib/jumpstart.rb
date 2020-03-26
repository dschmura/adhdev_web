require "jumpstart/account_middleware"
require "jumpstart/clients"
require "jumpstart/configuration"
require "jumpstart/controller"
require "jumpstart/credentials_generator"
require "jumpstart/engine"
require "jumpstart/job_processor"
require "jumpstart/mailer"
require "jumpstart/multitenancy"
require "jumpstart/omniauth"
require "jumpstart/subscription_extensions"
require "jumpstart/administrate_helpers"

module Jumpstart
  mattr_accessor :config
  @@config = {}

  def self.restart
    Bundler.original_system("rails restart")
  end

  # https://stackoverflow.com/a/25615344/277994
  def self.bundle
    Bundler.original_system("bundle")
  end

  def self.find_plan(id)
    return if id.nil?
    config.plans.find { |plan| plan["id"].to_s == id.to_s }
  end

  def self.processor_plan_id_for(id, interval, processor)
    find_plan(id)[interval]["#{processor}_id"]
  end

  def self.credentials
    Rails.application.credentials
  end
end
