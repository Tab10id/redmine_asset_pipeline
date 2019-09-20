# frozen_string_literal: true

module RedminePluginAssetPipeline
  # Register configuration options for library
  class Configuration
    alias [] public_send

    attr_accessor :use_ln

    def initialize
      @use_ln = false
    end
  end
end
