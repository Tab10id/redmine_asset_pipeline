require "redmine_asset_pipeline/version"

module RedmineAssetPipeline
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
	config.assets.js_compressor = :yui
	config.assets.paths << "#{config.root}/public/plugin_assets"
	
	# TODO: delete environment hardcode
	config.assets.debug = Rails.env.eql?("production") ? false : true
	config.assets.compile = Rails.env.eql?("production") ? false : true
	config.assets.compress = Rails.env.eql?("production") ? true : false
      end
    end
  end
end
