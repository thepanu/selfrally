require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SelfRally
  Raven.configure do |config|
    config.dsn = 'https://680cad95fa49421ca9a1fd23188943c1:58ae2399b0444c41b744547ddda38e9a@sentry.io/1214319'
  end
  
  # Application comment here #TODO
  class Application < Rails::Application
    config.time_zone = 'Europe/Helsinki'
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths += %W(#{config.root}/lib)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    # config.generators.system_tests = nil
    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
    end

    # Disable formatting of field_with_errors in forms
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
      html_tag
    }

  end
end
