require "redmine_plugin_asset_pipeline/version"

module RedminePluginAssetPipeline
  # Run the classic redmine plugin initializer after rails boot
  class Plugin < ::Rails::Engine
    config.after_initialize do
      require File.expand_path("../../init", __FILE__)
    end

    #asset pipeline configuration
    #enable asset pipeline before sprockets boots
    initializer 'redmine.asset_pipeline', :before => 'sprockets.environment' do
      RedmineApp::Application.configure do
        config.assets.enabled = true
        config.assets.prefix = '' # Redmine save all assets in root of public =(
        config.assets.css_compressor = :yui
        config.assets.js_compressor = :uglifier
        config.assets.paths << "#{config.root}/public/plugin_assets"
        config.assets.initialize_on_precompile = false
        
        # TODO: delete environment hardcode
        config.assets.precompile += %w(*/stylesheets/* */javascripts/*)
        config.assets.debug = Rails.env.eql?("production") ? false : true
        config.assets.compile = Rails.env.eql?("production") ? false : true
        config.assets.compress = Rails.env.eql?("production") ? true : false
      end
    end

    config.to_prepare do
      require_dependency 'redmine_plugin_asset_pipeline/application_helper_patch'
    end
  end
end
