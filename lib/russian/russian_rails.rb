# frozen_string_literal: true

require_relative "active_model_ext/custom_error_message"
require_relative "action_view_ext/helpers/date_helper"

module Russian
  # Installs Rails-specific patches exposed by the gem.
  #
  # The integration is lazy: outside Rails it does nothing, and inside Rails it
  # wires itself through `ActiveSupport.on_load` hooks and also patches
  # framework components that are already loaded.
  #
  #
  # Устанавливает Rails-специфичные патчи, поставляемые gem'ом.
  #
  # Интеграция сделана "ленивой": вне Rails она ничего не делает,
  # а внутри Rails подключается через `ActiveSupport.on_load` и
  # дополнительно патчит уже загруженные части фреймворка.
  #
  # @example
  #   require "russian"
  #   Russian::RailsIntegration.install!
  module RailsIntegration
    module_function

    # Installs Rails hooks and applies patches to already loaded components.
    #
    # The method is idempotent and safe to call more than once.
    #
    #
    # Устанавливает Rails-хуки и применяет патчи к уже загруженным компонентам.
    #
    # Метод идемпотентен и безопасен для повторных вызовов.
    #
    # @return [void]
    #
    # @example
    #   Russian::RailsIntegration.install!
    def install!
      return unless rails?

      define_railtie!
      install_hooks!

      patch_active_model! if defined?(ActiveModel::Error)
      patch_action_view! if defined?(ActionView::Helpers::DateTimeSelector)
    end

    # @private
    def install_hooks!
      return if @hooks_installed

      %i[active_model active_model_error].each { |hook| on_load(hook, :patch_active_model!) }
      on_load(:action_view, :patch_action_view!)

      @hooks_installed = true
    end

    # @private
    def on_load(hook, patcher)
      ActiveSupport.on_load(hook) { Russian::RailsIntegration.public_send(patcher) }
    end

    # @private
    def patch_active_model!
      patch!(ActiveModel::Error.singleton_class, Russian::ActiveModelExt::ErrorPatch)
    end

    # @private
    def patch_action_view!
      patch!(ActionView::Helpers::DateHelper, Russian::ActionViewExt::Helpers::DateHelperPatch)
      patch!(ActionView::Helpers::DateTimeSelector, Russian::ActionViewExt::Helpers::DateTimeSelectorPatch)
    end

    # @private
    def patch!(target, extension)
      target.prepend(extension) unless target < extension
    end

    # @private
    def rails?
      defined?(Rails::Railtie) && defined?(ActiveSupport) && ActiveSupport.respond_to?(:on_load)
    end

    # @private
    def define_railtie!
      return unless defined?(Rails::Railtie)
      return if defined?(Russian::Railtie)

      Russian.const_set(:Railtie, Class.new(Rails::Railtie) do
        initializer "russian.install" do
          Russian::RailsIntegration.install!
        end
      end)
    end
  end
end

Russian::RailsIntegration.install!
