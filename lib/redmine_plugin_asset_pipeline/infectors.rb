# frozen_string_literal: true

module RedminePluginAssetPipeline
  # collection of monkey patches
  module Infectors
    extend ActiveSupport::Autoload
    autoload :Redmine
    autoload :ApplicationHelper
  end
end