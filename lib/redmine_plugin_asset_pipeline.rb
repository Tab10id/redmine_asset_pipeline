require 'redmine_plugin_asset_pipeline/version'
require 'redmine_plugin_asset_pipeline/plugin'

module RedminePluginAssetPipeline
  extend ActiveSupport::Autoload
  autoload :Configuration
  autoload :Infectors

  def self.configure
    self.config ||= Configuration.new
    yield(self.config)
  end

  def self.config
    @config
  end

  private

  def self.config=(value)
    @config = value
  end
end
