module SmartCache
  module Config
    class << self
      attr_accessor :entries

      def entry(key, models:, path:, controller:, action:)
        @entries = [] if @entries.nil?
        @entries << SmartCache::Config::Entry.new(
          key: key, models: models, path: path, controller: controller, action: action
        )
        add_after_save
      end

      def database(adapter, url)
        SmartCache::Config::Database.adapter = adapter
        SmartCache::Config::Database.url     = url
      end

      def base_controller(base_controller)
        SmartCache::Config::BaseController.controller = base_controller
        SmartCache::Callbacks.add_render_to_base_controller
      end

      def is_path_included?(path)
        @entries.find { |e| e.path == path }
      end

      def lookup_entry_by_path(path)
        @entries.find { |e| e.path == path }
      end

      def lookup_entry_by_key(key)
        @entries.find { |e| e.key == key }
      end

      def entries_by_model(model)
        @entries.select { |e| e.models.include?(model) }
      end

      private

      def add_after_save
        @entries.each do |entry|
          SmartCache::Callbacks.add_after_save(entry)
        end
      end
    end
  end
end
