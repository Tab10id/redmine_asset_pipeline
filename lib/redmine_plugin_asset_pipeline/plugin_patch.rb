# Patch for copy plugin assets sources to private directory
module RedminePluginAssetPipeline
  module PluginPatch
    def self.included(base)

      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        class << self
          cattr_accessor :private_directory
          self.private_directory = File.join(Rails.root, 'private', 'plugin_assets')
        end

        alias_method :mirror_assets_to_public, :mirror_assets
        alias_method :mirror_assets, :mirror_assets_to_private
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def private_directory
        File.join(self.class.private_directory, id.to_s)
      end

      def mirror_assets_to_private
        source = assets_directory
        destination = private_directory
        return unless File.directory?(source)

        source_files = Dir[source + "/**/*"]
        source_dirs = source_files.select { |d| File.directory?(d) }
        source_files -= source_dirs

        unless source_files.empty?
          base_target_dir = File.join(destination, File.dirname(source_files.first).gsub(source, ''))
          begin
            FileUtils.mkdir_p(base_target_dir)
          rescue Exception => e
            raise "Could not create directory #{base_target_dir}: " + e.message
          end
        end

        source_dirs.each do |dir|
          # strip down these paths so we have simple, relative paths we can
          # add to the destination
          target_dir = File.join(destination, dir.gsub(source, ''))
          begin
            FileUtils.mkdir_p(target_dir)
          rescue Exception => e
            raise "Could not create directory #{target_dir}: " + e.message
          end
        end

        source_files.each do |file|
          begin
            target = File.join(destination, file.gsub(source, ''))
            unless File.exist?(target) && FileUtils.identical?(file, target)
              FileUtils.cp(file, target)
            end
          rescue Exception => e
            raise "Could not copy #{file} to #{target}: " + e.message
          end
        end
      end
    end
  end
end
