require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WonderfulEditor
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    # config.load_defaults 7.0 #参考サイトより

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
    # Task5-4で追記
    config.generators do |g|
      g.template_engine false
      g.javascripts false
      g.stylesheets false
      g.helper false
      g.test_framework :rspec,
                       view_specs: false,
                       routing_specs: false,
                       helper_specs: false,
                       controller_specs: false,
                       request_specs: true
    end
    config.api_only = true
    # Task9-1で追加（なにこれ？）
    # config.session_store :cookie_store, key: '_interslice_session'
    # config.middleware.use ActionDispatch::Cookies
    # config.middleware.use config.session_store, config.session_options
    config.middleware.use ActionDispatch::Flash
  end
end
