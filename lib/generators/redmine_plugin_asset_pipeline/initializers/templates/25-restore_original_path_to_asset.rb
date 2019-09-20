# frozen_string_literal: true

module ActionView
  module Helpers
    # return original method after override
    # (in 10-patches initializer in redmine)
    module AssetUrlHelper
      alias path_to_asset original_path_to_asset
    end
  end
end