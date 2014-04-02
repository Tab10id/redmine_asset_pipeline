module RedminePipeline
  class PrivateAssetsInitializerGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    def copy_initializer_file
      file_name = '35-patch_assets_mirror'
      copy_file "#{file_name}.rb", "config/initializers/#{file_name}.rb"
    end
  end
end