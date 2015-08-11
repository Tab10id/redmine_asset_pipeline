class RedminePluginAssetPipeline::Configuration
  attr_accessor :use_ln

  def initialize
    @use_ln = false
  end

  def [](value)
    self.public_send(value)
  end
end