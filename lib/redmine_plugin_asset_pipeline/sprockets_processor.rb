# frozen_string_literal: true

module RedminePluginAssetPipeline
  # This processor subclasses the standard Sprockets::DirectiveProcessor
  # as advised in Sprockets, to add a new directive called
  # "require_redmine_plugins". This directive is relative to the
  # #{Rails.root}/plugins/ directory and accepts wildcards.
  #
  # For convenience, it also replaces "ALL" by a star ("*") before
  # evaluating the globing. Otherwise, "*/" is interpreted as the end of
  # the comment in CSS files, which is obviously problematic.
  #
  #
  # For the record, here's the example custom require provided in sprockets:
  #
  # def process_require_glob_directive
  #  Dir["#{pathname.dirname}/#{glob}"].sort.each do |filename|
  #    require(filename)
  #  end
  # end
  class SprocketsProcessor < Sprockets::DirectiveProcessor
    def process_require_redmine_plugins_directive(type, prefix = '')
      assets_root = Rails.root.join(Redmine::Plugin.private_directory_base)
      mask = assets_root.join("*/#{type}/#{prefix}_common_part*").expand_path
      Dir.glob(mask).sort.each do |entry|
        @required <<
          resolve(
            Pathname.new(entry).relative_path_from(assets_root).to_s,
            accept: @content_type,
            pipeline: :self
          )
      end
    end
  end
end
