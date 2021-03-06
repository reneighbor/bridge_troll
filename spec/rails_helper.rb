ENV["RAILS_ENV"] ||= 'test'

require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'
require 'webmock/rspec'

Capybara.javascript_driver = :poltergeist
Capybara.asset_host = "http://#{Rails.application.routes.default_url_options[:host]}"

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.use_transactional_fixtures = true

  config.before(:each) do
    # Remove after https://github.com/mattheworiordan/capybara-screenshot/pull/126
    Capybara.save_and_open_page_path = Rails.root.join('tmp/capybara')
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  config.include Devise::TestHelpers, type: :controller

  config.include FactoryGirl::Syntax::Methods

  [:feature, :request].each do |type|
    config.include Warden::Test::Helpers, type: type
    config.after(:example, type: type) do
      Warden.test_reset!
    end
  end
end
