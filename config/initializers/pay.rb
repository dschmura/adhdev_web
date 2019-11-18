Pay.setup do |config|
  config.billable_class = "Team"
  config.billable_table = "teams"

  config.application_name = Jumpstart.config.application_name
  config.business_name    = Jumpstart.config.business_name
  config.business_address = Jumpstart.config.business_address
  config.support_email    = Jumpstart.config.support_email

  config.routes_path = '/'
end
