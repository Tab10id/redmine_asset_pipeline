module RedminePipeline
  class PrivateAssetsInitializerGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    def copy_initializer_file
      unpatch = '09-unpatch_10_patches'
      copy_file "#{unpatch}.rb", "config/initializers/#{unpatch}.rb"
      patch = '25-patch_assets_mirror'
      copy_file "#{patch}.rb", "config/initializers/#{patch}.rb"
    end
  end
end