# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redmine_plugin_asset_pipeline/version'

Gem::Specification.new do |spec|
  spec.name          = 'redmine_plugin_asset_pipeline'
  spec.version       = RedminePluginAssetPipeline::VERSION
  spec.authors       = ['Tab10id']
  spec.email         = ['tabloidmeister@gmail.com']
  spec.description   = 'Asset pipeline for Redmine'
  spec.summary       = 'Asset pipeline for Redmine'
  spec.homepage      = 'https://github.com/Tab10id/redmine_plugin_asset_pipeline'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '~> 5.2'
  spec.add_dependency 'sprockets-rails', '~> 3.2'
  spec.add_development_dependency 'bundler', '~> 2.0'
end
