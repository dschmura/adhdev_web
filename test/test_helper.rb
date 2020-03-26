ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/mock"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def switch_account(account)
    patch "/accounts/#{account.id}/switch"
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
