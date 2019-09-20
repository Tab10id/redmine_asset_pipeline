# frozen_string_literal: true

require 'redmine_plugin_asset_pipeline/sprockets_processor'

module RedminePluginAssetPipeline
  # Initialize Sprockets
  # Register `require_redmine_plugins` directives
  # MonkeyPatching of `ApplicationHelper`
  class Plugin < ::Rails::Engine
    # asset pipeline configuration
    # enable asset pipeline before sprockets boots
    initializer 'redmine.asset_pipeline', before: 'sprockets.environment' do
      RedmineApp::Application.configure do
        config.assets.paths << "#{config.root}/private/plugin_assets"
        config.assets.precompile +=
          %w[*/stylesheets/*.css */javascripts/*.js */images/* */fonts/*]
      end
    end

    # Register our processor
    # (subclass of the standard one which adds a directive for redmine plugins)
    initializer 'redmine.sprockets_processor', after: 'sprockets.environment' do
      RedmineApp::Application.config.assets.configure do |env|
        env.unregister_preprocessor(
          'text/css',
          Sprockets::DirectiveProcessor
        )
        env.register_preprocessor(
          'text/css',
          RedminePluginAssetPipeline::SprocketsProcessor
        )
        env.unregister_preprocessor(
          'application/javascript',
          Sprockets::DirectiveProcessor
        )
        env.register_preprocessor(
          'application/javascript',
          RedminePluginAssetPipeline::SprocketsProcessor
        )
      end
    end

    config.to_prepare do
      require_dependency 'application_helper'

      patch = RedminePluginAssetPipeline::Infectors::ApplicationHelper

      unless ApplicationHelper.included_modules.include?(patch)
        ApplicationHelper.include(patch)
      end
    end

    config.before_configuration do
      require_dependency 'redmine/plugin'

      patch = RedminePluginAssetPipeline::Infectors::Redmine::Plugin

      unless Redmine::Plugin.included_modules.include?(patch)
        Redmine::Plugin.include(patch)
      end
    end
  end
end
