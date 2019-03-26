module Jumpstart
  class Mailer
    attr_reader :config

    def initialize(config)
      @config = config
    end

    # rubocop: disable Metrics/AbcSize
    def settings
      return mailgun_settings    if config.mailgun?
      return mailjet_settings    if config.mailjet?
      return mandrill_settings   if config.mandrill?
      return postmark_settings   if config.postmark?
      return sendgrid_settings   if config.sendgrid?
      return sendinblue_settings if config.sendinblue?
      return ses_settings        if config.ses?
      return sparkpost_settings  if config.sparkpost?
      {}
    end
    # rubocop: enable Metrics/AbcSize

    private

    def credentials
      Rails.application.credentials
    end

    def shared_settings
      {
        port: 587,
        authentication: :plain,
        enable_starttls_auto: true
      }
    end

    def mailgun_settings
      {
        address: 'smtp.mailgun.org',
        user_name: credentials.dig(Rails.env.to_sym, :mailgun, :username),
        password:  credentials.dig(Rails.env.to_sym, :mailgun, :password),
      }.merge(shared_settings)
    end

    def mailjet_settings
      {
        address:   'in.mailjet.com',
        user_name: credentials.dig(Rails.env.to_sym, :mailjet, :username),
        password:  credentials.dig(Rails.env.to_sym, :mailjet, :password),
      }.merge(shared_settings)
    end

    def mandrill_settings
      {
        address:   'smtp.mandrillapp.com',
        user_name: credentials.dig(Rails.env.to_sym, :mandrill, :username),
        password:  credentials.dig(Rails.env.to_sym, :mandrill, :password),
      }.merge(shared_settings)
    end

    def postmark_settings
      {
        address:   'smtp.postmarkapp.com',
        user_name: credentials.dig(Rails.env.to_sym, :postmark, :username),
        password:  credentials.dig(Rails.env.to_sym, :postmark, :password),
      }.merge(shared_settings)
    end

    def sendinblue_settings
      shared_settings.merge({
        address:        'smtp-relay.sendinblue.com',
        authentication: 'login',
        user_name: credentials.dig(Rails.env.to_sym, :sendinblue, :username),
        password:  credentials.dig(Rails.env.to_sym, :sendinblue, :password),
      })
    end

    def sendgrid_settings
      {
        address:   'smtp.sendgrid.net',
        domain:    credentials.dig(Rails.env.to_sym, :sendgrid, :domain),
        user_name: credentials.dig(Rails.env.to_sym, :sendgrid, :username),
        password:  credentials.dig(Rails.env.to_sym, :sendgrid, :password),
      }.merge(shared_settings)
    end

    def ses_settings
      {
        address:   credentials.dig(Rails.env.to_sym, :ses, :address),
        user_name: credentials.dig(Rails.env.to_sym, :ses, :username),
        password:  credentials.dig(Rails.env.to_sym, :ses, :password),
      }.merge(shared_settings)
    end

    def sparkpost_settings
      {
        address:   'smtp.sparkpostmail.com',
        user_name: 'SMTP_Injection',
        password:  credentials.dig(Rails.env.to_sym, :sparkpost, :password),
      }.merge(shared_settings)
    end
  end
end
