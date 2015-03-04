# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'factory_girl_rails'
require 'rspec/rails'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.infer_spec_type_from_file_location!
  config.deprecation_stream = Rails.root.join 'tmp/rspec_deprecations.log'
  config.include FactoryGirl::Syntax::Methods
end

WebMock.disable_net_connect!(allow_localhost: true)

# Uncomment these lines to setup VCR, for recording and replaying
# external HTTP requests, for integrating with other APIs
# require 'vcr'
# VCR.configure do |config|
#   config.cassette_library_dir = 'fixtures/vcr_cassettes'
#   config.hook_into :webmock
#   config.ignore_localhost true
# end
