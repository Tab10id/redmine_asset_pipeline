# frozen_string_literal: true

require 'redmine_plugin_asset_pipeline/version'
require 'redmine_plugin_asset_pipeline/plugin'

# Library for activate asset pipeline in redmine
module RedminePluginAssetPipeline
  extend ActiveSupport::Autoload
  autoload :Configuration
  autoload :Infectors

  class << self
    attr_reader :config

    def configure
      self.config ||= Configuration.new
      yield(self.config)
    end

    private

    attr_writer :config
  end
end
