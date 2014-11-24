require_dependency 'application_helper'

module ApplicationHelper
  def stylesheet_link_tag(*sources)
    options = sources.extract_options!
    plugin  = options.delete(:plugin)
    debug   = options.key?(:debug) ? options.delete(:debug) : debug_assets?
    body    = options.key?(:body) ? options.delete(:body) : false
    digest  = options.key?(:digest) ? options.delete(:digest) : digest_assets?
    sources.map! do |source|
      if plugin
        "#{plugin}/stylesheets/#{source}"
      elsif current_theme && current_theme.stylesheets.include?(source)
        current_theme.stylesheet_path(source)
      else
        # NOTE: bugfix aka crutck for asset from gem
        ["stylesheets/#{source}", source]
      end
    end
    sources.collect do |source|
      if source.is_a?(Array)
        asset = source.collect{|s| asset_for(s, 'css')}.compact
        asset = asset.any? ? asset.first : source.first
      else
        asset = asset_for(source, 'css')
      end
      if debug && asset
        asset.to_a.map do |dep|
          single_asset_path = asset_path(dep, ext: 'css',
                                              body: true,
                                              protocol: :request,
                                              digest: digest)
          # TODO: here we must try to make more pretty solution
          next if single_asset_path.blank?
          super(dep.pathname.to_s, { href: single_asset_path }.merge!(options))
        end.compact
      else
        single_asset_path = asset_path(source, ext: 'css',
                                               body: body,
                                               protocol: :request,
                                               digest: digest)
        # TODO: here we must try to make more pretty solution
        next if single_asset_path.blank?
        super(source.to_s, { href: single_asset_path }.merge!(options))
      end
    end.flatten.compact.uniq.join("\n").html_safe
  end

  def javascript_include_tag(*sources)
    options = sources.last.is_a?(Hash) ? sources.pop : {}
    plugin  = options.delete(:plugin)
    debug   = options.key?(:debug) ? options.delete(:debug) : debug_assets?
    body    = options.key?(:body) ? options.delete(:body) : false
    digest  = options.key?(:digest) ? options.delete(:digest) : digest_assets?
    sources.map! do |source|
      if plugin
        "#{plugin}/javascripts/#{source}"
      else
        # NOTE: bugfix aka crutck for asset from gem
        ["javascripts/#{source}", source]
      end
    end
    sources.collect do |source|
      if source.is_a?(Array)
        asset = source.collect{|s| asset_for(s, 'js')}.compact
        asset = asset.any? ? asset.first : source.first
      else
        asset = asset_for(source, 'js')
      end
      if debug && asset
        asset.to_a.map do |dep|
          single_asset_path = asset_path(dep, ext: 'js',
                                              body: true,
                                              digest: digest)
          # TODO: here we must try to make more pretty solution
          next if single_asset_path.blank?
          super(dep.pathname.to_s, { src: single_asset_path }.merge!(options))
        end.compact
      else
        single_asset_path = asset_path(source, ext: 'js',
                                               body: body,
                                               digest: digest)
        # TODO: here we must try to make more pretty solution
        next if single_asset_path.blank?
        super(source.to_s, { src: single_asset_path }.merge!(options))
      end
    end.flatten.compact.uniq.join("\n").html_safe
  end

  def image_tag(source, options={})
    if plugin = options.delete(:plugin)
      source = "#{plugin}/images/#{source}"
    elsif current_theme && current_theme.images.include?(source)
      source = current_theme.image_path(source)
    elsif source[0] != '/'
      source = "images/#{source}"
    end
    super source, options
  end

  def include_calendar_headers_tags
    unless @calendar_headers_tags_included
      @calendar_headers_tags_included = true
      content_for :header_tags do
        start_of_week = Setting.start_of_week
        start_of_week = l(:general_first_day_of_week, default: '1') if start_of_week.blank?
        # Redmine uses 1..7 (monday..sunday) in settings and locales
        # JQuery uses 0..6 (sunday..saturday), 7 needs to be changed to 0
        start_of_week = start_of_week.to_i % 7

        tags = javascript_tag(
            "var datepickerOptions={dateFormat: 'yy-mm-dd', firstDay: #{start_of_week}, " +
                "showOn: 'button', buttonImageOnly: true, buttonImage: '" +
                path_to_image('images/calendar.png') +
                "', showButtonPanel: true, showWeek: true, showOtherMonths: true, selectOtherMonths: true};")
        jquery_locale = l('jquery.locale', default: current_language.to_s)
        unless jquery_locale == 'en'
          tags << javascript_include_tag("i18n/jquery.ui.datepicker-#{jquery_locale}.js")
        end
        tags
      end
    end
  end

  private

  # copy-paste from Sprocket
  def debug_assets?
    compile_assets? && (Rails.application.config.assets.debug || params[:debug_assets])
  rescue NameError
    false
  end

  def compile_assets?
    Rails.application.config.assets.compile
  end

  def digest_assets?
    Rails.application.config.assets.digest
  end

  def asset_path(source, options = {})
    source = source.logical_path if source.respond_to?(:logical_path)
    path = asset_paths.compute_public_path(source, assets_prefix, options.merge(body: true))
    options[:body] ? "#{path}?body=1" : path
  end

  def assets_prefix
    Rails.application.config.assets.prefix.gsub(/^\//, '')
  end

  def asset_for(source, ext)
    source = source.to_s
    return nil if asset_paths.is_uri?(source)
    source = rewrite_extension(source, ext)
    Rails.application.assets[source]
  rescue Sprockets::FileOutsidePaths
    nil
  end

  def rewrite_extension(source, ext)
    source_ext = File.extname(source)[1..-1]

    if !ext || ext == source_ext
      source
    elsif source_ext.blank?
      "#{source}.#{ext}"
    elsif File.exists?(source) || exact_match_present?(source)
      source
    else
      "#{source}.#{ext}"
    end
  end

  def exact_match_present?(source)
    pathname = Rails.application.assets.resolve(source)
    pathname.to_s =~ /#{Regexp.escape(source)}\Z/
  rescue Sprockets::FileNotFound
    false
  end
end
