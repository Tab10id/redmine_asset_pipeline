module RedminePluginAssetPipeline
  module ApplicationHelperPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        def assets_prefix
          Rails.application.config.assets.prefix.gsub(/^\//, '')
        end

        def stylesheet_link_tag(*sources)
          options = sources.last.is_a?(Hash) ? sources.pop : {}
          plugin = options.delete(:plugin)
          sources = sources.map do |source|
            if plugin
              "/#{[assets_prefix, "#{plugin}/stylesheets/#{source}"].join('/')}"
            elsif current_theme && current_theme.stylesheets.include?(source)
              current_theme.stylesheet_path(source)
            else
              "/#{[assets_prefix, "stylesheets/#{source}"].join('/')}"
            end
          end
          super *sources, options
        end

        def javascript_include_tag(*sources)
          options = sources.last.is_a?(Hash) ? sources.pop : {}
          plugin = options.delete(:plugin)
          sources = sources.map do |source|
            if plugin
              "/#{[assets_prefix, "#{plugin}/javascripts/#{source}"].join('/')}"
            else
              "/#{[assets_prefix, "javascripts/#{source}"].join('/')}"
            end
          end
          super *sources, options
        end

        def image_tag(source, options={})
          if plugin = options.delete(:plugin)
            source = "/#{[assets_prefix, "#{plugin}/images/#{source}"].join('/')}"
          elsif current_theme && current_theme.images.include?(source)
            source = current_theme.image_path(source)
          else
            source = "/#{[assets_prefix, "images/#{source}"].join('/')}"
          end
          super source, options
        end
      end
    end

    module InstanceMethods
    end
  end
end
