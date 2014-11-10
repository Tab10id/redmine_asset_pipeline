Rails.configuration.before_configuration do
  require_dependency 'redmine_plugin_asset_pipeline/plugin_patch'
  unless Redmine::Plugin.included_modules.include? RedminePluginAssetPipeline::PluginPatch
    Redmine::Plugin.send(:include, RedminePluginAssetPipeline::PluginPatch)
  end
end

RedminePluginAssetPipeline.configure do |config|
  if Rails.env.development?
    config.use_ln = true
  end
end