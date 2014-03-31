require 'redmine'
require 'redmine_asset_pipeline/version'

Redmine::Plugin.register :redmine_plugin_asset_pipeline do
  name 'Redmine Plugin Asset Pipeline plugin'
  description 'This plugin adds asset pipeline support for redmine plugins'
  url 'https://github.com/Tab10id/redmine_plugin_asset_pipeline'
  version RedmineAssetPipeline::VERSION
  requires_redmine :version_or_higher => '2.1.0'
end
