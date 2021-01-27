require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  test "can login" do
    Capybara.app_host = 'http://lvh.me'
    Capybara.always_include_port = true

    visit new_user_session_path

    fill_in 'user[email]', with: users(:one).email
    fill_in 'user[password]', with: 'password'

    find('input[name="commit"]').click

    assert_selector "p", text: I18n.t("devise.sessions.signed_in")
  end
end
