Redmine::Plugin.register :redmine_plugin_asset_pipeline do
  name 'Redmine Plugin Asset Pipeline plugin'
  description 'This plugin adds asset pipeline support for redmine plugins'
  url 'https://github.com/Tab10id/redmine_plugin_asset_pipeline'
  version RedminePluginAssetPipeline::VERSION
  requires_redmine version_or_higher: '3.0.0'
end
