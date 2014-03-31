require_dependency 'application_helper'

module RedminePluginAssetPipeline
  module ApplicationHelperPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        def stylesheet_link_tag(*sources)
          options = sources.last.is_a?(Hash) ? sources.pop : {}
          plugin = options.delete(:plugin)
          sources = sources.map do |source|
            if plugin && plugin != 'application'
              "/#{plugin}/stylesheets/#{source}"
            elsif current_theme && current_theme.stylesheets.include?(source)
              current_theme.stylesheet_path(source)
            else
              "/stylesheets/#{source}"
            end
          end
          super *sources, options
        end

        def javascript_include_tag(*sources)
          options = sources.last.is_a?(Hash) ? sources.pop : {}
          plugin = options.delete(:plugin)
          sources = sources.map do |source|
            if plugin && plugin != 'application'
              "/#{plugin}/javascripts/#{source}"
            else
              "/javascripts/#{source}"
            end
          end
          super *sources, options
        end
      end
    end

    module InstanceMethods
    end
  end
end