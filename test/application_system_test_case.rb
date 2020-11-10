require "test_helper"

Dir["#{File.dirname(__FILE__)}/support/system/**/*.rb"].sort.each { |f| require f }

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  include Warden::Test::Helpers
  include StripeSystemTestHelper
  include TrixSystemTestHelper

  def switch_account(account)
    visit test_switch_account_url(account)
  end
end

Capybara.default_max_wait_time = 10

# Add a route for easily switching accounts in system tests
Rails.application.routes.append do
  get "/accounts/:id/switch", to: "accounts#switch", as: :test_switch_account
end
Rails.application.reload_routes!
