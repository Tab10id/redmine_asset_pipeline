require 'redmine_plugin_asset_pipeline/version'

module RedminePluginAssetPipeline
  # Run the classic redmine plugin initializer after rails boot
  class Plugin < ::Rails::Engine
    config.after_initialize do
      require File.expand_path('../../init', __FILE__)
    end

    #asset pipeline configuration
    #enable asset pipeline before sprockets boots
    initializer 'redmine.asset_pipeline', :before => 'sprockets.environment' do
      RedmineApp::Application.configure do
        config.assets.enabled = true
        config.assets.paths << "#{config.root}/private/plugin_assets"
        config.assets.precompile += %w(*/stylesheets/*.css */javascripts/*.js)

        # Custom settings. Edit configs of your application
        # See: http://guides.rubyonrails.org/asset_pipeline.html
        #
        # Redmine save all assets in root of public =(
        # If you need to change that value
        # manually move assets in public directory and edit it
        # config.assets.prefix = ''
        #
        # config.assets.js_compressor = :uglifier
        #
        # config.assets.debug = true
        #
        # config.assets.compile = true
        #
        # config.assets.compress = false
      end
    end

    config.after_initialize do
      require_dependency 'redmine_plugin_asset_pipeline/application_helper_patch'
      unless ApplicationHelper.included_modules.include? RedminePluginAssetPipeline::ApplicationHelperPatch
        ApplicationHelper.send(:include, RedminePluginAssetPipeline::ApplicationHelperPatch)
      end
    end

  end
end
