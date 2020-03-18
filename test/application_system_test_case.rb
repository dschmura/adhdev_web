require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  include Warden::Test::Helpers

  def fill_stripe_elements(card:, expiry: "1234", cvc: "123", postal: "12345", selector: '[data-target="stripe.card"] > div > iframe')
    find_frame(selector) do
      card.to_s.chars.each do |piece|
        find_field("cardnumber").send_keys(piece)
      end

      find_field("exp-date").send_keys expiry
      find_field("cvc").send_keys cvc
      find_field("postal").send_keys postal
    end
  end

  def complete_stripe_sca
    find_frame("body > div > iframe") do
      sleep 1
      find_frame("#challengeFrame") do
        click_on "Complete authentication"
      end
    end
  end

  def fail_stripe_sca
    find_frame("body > div > iframe") do
      sleep 1
      find_frame("#challengeFrame") do
        click_on "Fail authentication"
      end
    end
  end

  def find_frame(selector, &block)
    using_wait_time(15) do
      frame = find(selector)
      within_frame(frame) do
        block.call
      end
    end
  end
end

Capybara.default_max_wait_time = 10
