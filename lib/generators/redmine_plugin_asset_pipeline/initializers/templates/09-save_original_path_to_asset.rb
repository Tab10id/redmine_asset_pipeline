# frozen_string_literal: true

module ActionView
  module Helpers
    # save original method before it will overridden
    # (in 10-patches initializer in redmine)
    module AssetUrlHelper
      alias original_path_to_asset path_to_asset
    end
  end
end
