require 'redmine'
require 'redmine_plugin_asset_pipeline/version'

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'application_helper'
  unless ApplicationHelper.included_modules.include? RedminePluginAssetPipeline::ApplicationHelperPatch
    ApplicationHelper.send(:include, RedminePluginAssetPipeline::ApplicationHelperPatch)
  end
end

Redmine::Plugin.register :redmine_plugin_asset_pipeline do
  name 'Redmine Plugin Asset Pipeline plugin'
  description 'This plugin adds asset pipeline support for redmine plugins'
  url 'https://github.com/Tab10id/redmine_plugin_asset_pipeline'
  version RedminePluginAssetPipeline::VERSION
  requires_redmine :version_or_higher => '2.1.0'
end
