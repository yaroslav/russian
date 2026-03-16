# frozen_string_literal: true

require "logger"
require "rails"
require "action_controller/railtie"
require "active_model/railtie"
require "action_view/railtie"
require "active_support/railtie"

require_relative "../../../lib/russian"

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path("..", __dir__)
    config.load_defaults("#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}")
    config.eager_load = false
    config.logger = Logger.new(nil)
    config.secret_key_base = "dummy-secret-key-base"
  end
end
