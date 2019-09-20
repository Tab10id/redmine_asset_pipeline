# frozen_string_literal: true

module RedminePluginAssetPipeline
  # :nodoc:
  class InitializersGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def copy_initializer_file
      save = '09-save_original_path_to_asset'
      copy_file "#{save}.rb", "config/initializers/#{save}.rb"

      restore = '25-restore_original_path_to_asset'
      copy_file "#{restore}.rb", "config/initializers/#{restore}.rb"
    end
  end
end