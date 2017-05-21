module SmartCache
  module Cache
    module Global
      extend self

      def read(entry)
        "SmartCache::Database::#{SmartCache::Config::Database.adapter}".constantize.read(entry)
      end
    end
  end
end