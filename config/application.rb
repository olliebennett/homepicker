# frozen_string_literal: true

require_relative 'boot'

# Require specific railtie individually, not 'rails/all'
# See: https://github.com/rails/rails/blob/master/railties/lib/rails/all.rb
require 'active_record/railtie'
# require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'active_job/railtie'
# require 'action_cable/engine'
# require 'action_mailbox/engine'
# require 'action_text/engine'
# require 'rails/test_unit/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Homepicker
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Force pages to be served via HTTPS if configured
    config.force_ssl = ENV.fetch('SITE_PROTOCOL', 'http') == 'https'

    # Define URL defaults for use in email links
    config.action_mailer.default_url_options = {
      host: ENV.fetch('SITE_HOST', 'localhost'),
      port: ENV.fetch('SITE_PORT', 80).to_i,
      protocol: ENV.fetch('SITE_PROTOCOL', 'http')
    }

    config.after_initialize do
      # Ensure availability of xyz_url helpers in background jobs
      Rails.application.routes.default_url_options = config.action_mailer.default_url_options
    end

    config.time_zone = 'Europe/London'
  end
end
