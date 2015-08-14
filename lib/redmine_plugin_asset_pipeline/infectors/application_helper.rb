module RedminePluginAssetPipeline::Infectors::ApplicationHelper
  extend ActiveSupport::Concern

  included do
    def stylesheet_link_tag(*sources)
      options = sources.last.is_a?(Hash) ? sources.pop : {}
      plugin = options.delete(:plugin)
      sources = sources.map do |source|
        if plugin
          "#{plugin}/stylesheets/#{source}"
        elsif current_theme && current_theme.stylesheets.include?(source)
          current_theme.stylesheet_path(source)
        else
          # @note: assets from gems
          [source, "stylesheets/#{source}"].find do |s|
            asset_digest_path("#{s}#{compute_asset_extname(s, type: :stylesheet)}").present?
          end || source
        end
      end
      super *sources, options
    end

    def javascript_include_tag(*sources)
      options = sources.last.is_a?(Hash) ? sources.pop : {}
      plugin = options.delete(:plugin)
      sources = sources.map do |source|
        if plugin
          "#{plugin}/javascripts/#{source}"
        else
          # @note: assets from gems
          [source, "javascripts/#{source}"].find do |s|
            asset_digest_path("#{s}#{compute_asset_extname(s, type: :javascript)}").present?
          end || source
        end
      end
      super *sources, options
    end

    def image_tag(source, options={})
      plugin = options.delete(:plugin)
      if plugin
        source = "#{plugin}/images/#{source}"
      elsif current_theme && current_theme.images.include?(source)
        source = current_theme.image_path(source)
      else
        source = [source, "images/#{source}"].find{ |s| asset_digest_path(s).present? } || source
      end
      super source, options
    end

    # Only one fix - remove leading slash in path_to_image
    def include_calendar_headers_tags
      unless @calendar_headers_tags_included
        tags = ''.html_safe
        @calendar_headers_tags_included = true
        content_for :header_tags do
          start_of_week = Setting.start_of_week
          start_of_week = l(:general_first_day_of_week, :default => '1') if start_of_week.blank?
          # Redmine uses 1..7 (monday..sunday) in settings and locales
          # JQuery uses 0..6 (sunday..saturday), 7 needs to be changed to 0
          start_of_week = start_of_week.to_i % 7
          tags << javascript_tag(
              "var datepickerOptions={dateFormat: 'yy-mm-dd', firstDay: #{start_of_week}, " +
                  "showOn: 'button', buttonImageOnly: true, buttonImage: '" +
                  path_to_image('images/calendar.png') +
                  "', showButtonPanel: true, showWeek: true, showOtherMonths: true, " +
                  "selectOtherMonths: true, changeMonth: true, changeYear: true, " +
                  "beforeShow: beforeShowDatePicker};")
          jquery_locale = l('jquery.locale', :default => current_language.to_s)
          unless jquery_locale == 'en'
            tags << javascript_include_tag("i18n/datepicker-#{jquery_locale}.js")
          end
          tags
        end
      end
    end
  end
end
