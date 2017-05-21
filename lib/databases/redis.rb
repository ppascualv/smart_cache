module SmartCache
  module Databases
    module Redis
      extend self

      def connection
        @connection ||= ::Redis.new(
          url: SmartCache::Config::Database.url
        )
      end

      def read(entry)
        connection.hget(entry.key, 'view')
      end

      def write_async(key)
        entry = SmartCache::Config.lookup_entry_by_key(key)
        write(entry)
      end


      def write_sync(entry)
        write(entry)
      end

      private

      def write(entry)
        view = SmartCache::Config::Entry.view(entry.path)
        connection.hset(entry.key, 'timestamp', set_timestamp)
        connection.hset(entry.key, 'view', view)
      end

      def set_timestamp
        @timestamp ||= DateTime.now.strftime('%Q').to_i
      end
    end
  end
end
