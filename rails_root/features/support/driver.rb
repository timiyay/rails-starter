Capybara.default_wait_time = 5

if ENV['BROWSER']
  require 'selenium/webdriver'

  browser = ENV['BROWSER'].to_sym
  driver = "selenium_#{browser}".to_sym

  Capybara.register_driver driver do |app|
    Capybara::Selenium::Driver.new(app, browser: browser)
  end
  Capybara.javascript_driver = driver
else
  require 'capybara/poltergeist'

  Capybara.javascript_driver = :poltergeist
end
