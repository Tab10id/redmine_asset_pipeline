# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redmine_asset_pipeline/version'

Gem::Specification.new do |spec|
  spec.name          = "redmine_plugin_asset_pipeline"
  spec.version       = RedmineAssetPipeline::VERSION
  spec.authors       = ["Tab10id"]
  spec.email         = ["tabloidmeister@gmail.com"]
  spec.description   = %q{Asset pipeline for Redmine}
  spec.summary       = %q{Asset pipeline for Redmine}
  spec.homepage      = "https://github.com/Tab10id/redmine_plugin_asset_pipeline"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
