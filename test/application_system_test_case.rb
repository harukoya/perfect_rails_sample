require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  Capybara.register_driver :selenium_chrome_headless_nosandbox do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')

    driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  driven_by :selenium_chrome_headless_nosandbox
end
