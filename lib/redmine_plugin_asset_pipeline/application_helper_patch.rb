require_dependency 'application_helper'

module ApplicationHelper
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
    elsif source[0] != '/'
      source = "/#{[assets_prefix, "images/#{source}"].join('/')}"
    end
    super source, options
  end

  def include_calendar_headers_tags
    unless @calendar_headers_tags_included
      @calendar_headers_tags_included = true
      content_for :header_tags do
        start_of_week = Setting.start_of_week
        start_of_week = l(:general_first_day_of_week, :default => '1') if start_of_week.blank?
        # Redmine uses 1..7 (monday..sunday) in settings and locales
        # JQuery uses 0..6 (sunday..saturday), 7 needs to be changed to 0
        start_of_week = start_of_week.to_i % 7

        tags = javascript_tag(
            "var datepickerOptions={dateFormat: 'yy-mm-dd', firstDay: #{start_of_week}, " +
                "showOn: 'button', buttonImageOnly: true, buttonImage: '" +
                path_to_image('images/calendar.png') +
                "', showButtonPanel: true, showWeek: true, showOtherMonths: true, selectOtherMonths: true};")
        jquery_locale = l('jquery.locale', :default => current_language.to_s)
        unless jquery_locale == 'en'
          tags << javascript_include_tag("i18n/jquery.ui.datepicker-#{jquery_locale}.js")
        end
        tags
      end
    end
  end
end
