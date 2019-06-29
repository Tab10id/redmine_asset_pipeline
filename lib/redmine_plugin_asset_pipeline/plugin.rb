class RedminePluginAssetPipeline::Plugin < ::Rails::Engine
  config.after_initialize do
    require File.expand_path('../../../init', __FILE__)
  end

  #asset pipeline configuration
  #enable asset pipeline before sprockets boots
  initializer 'redmine.asset_pipeline', before: 'sprockets.environment' do
    RedmineApp::Application.configure do
      config.assets.paths << "#{config.root}/private/plugin_assets"
      config.assets.precompile += %w(*/stylesheets/*.css */javascripts/*.js */images/* */fonts/*)
      # Custom settings. Edit configs of your application
      # See: http://guides.rubyonrails.org/asset_pipeline.html
      #
      # Redmine save all assets in root of public =(
      # If you need to change that value
      # manually move assets in public directory and edit it
      # config.assets.prefix = ''
    end
  end

  #add all plugin directories in case some js/css/images are included directly or via relative css
  #it also avoids Sprocket's FileOutsidePaths errors
  # config.assets.paths += Dir.glob("#{config.root}/plugins/*/assets")
  #add our directory
  # config.assets.paths += Dir.glob("#{File.dirname(__FILE__)}/assets")
  #compression
  # config.assets.compress = true
  # config.assets.css_compressor = :yui
  # config.assets.js_compressor = :yui

  # Register our processor (subclass of the standard one which adds a directive for redmine plugins)
  initializer 'redmine.sprockets_processor', after: 'sprockets.environment' do
    require 'redmine_plugin_asset_pipeline/sprockets_processor'
    env = RedmineApp::Application.config.assets
    env.unregister_preprocessor('text/css', Sprockets::DirectiveProcessor)
    env.unregister_preprocessor('application/javascript', Sprockets::DirectiveProcessor)
    env.register_preprocessor('text/css', RedminePluginAssetPipeline::SprocketsProcessor)
    env.register_preprocessor('application/javascript', RedminePluginAssetPipeline::SprocketsProcessor)
  end

  config.to_prepare do
    require_dependency 'application_helper'
    unless ApplicationHelper.included_modules.include? RedminePluginAssetPipeline::Infectors::ApplicationHelper
      ApplicationHelper.send(:include, RedminePluginAssetPipeline::Infectors::ApplicationHelper)
    end
  end
end
