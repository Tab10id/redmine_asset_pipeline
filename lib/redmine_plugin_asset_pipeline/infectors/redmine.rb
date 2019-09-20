# frozen_string_literal: true

module RedminePluginAssetPipeline
  module Infectors
    # Collection of patches
    module Redmine
      extend ActiveSupport::Autoload
      autoload :Plugin
    end
  end
end
