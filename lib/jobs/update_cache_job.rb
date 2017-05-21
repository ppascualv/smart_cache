module SmartCache
  module Jobs
    class UpdateCacheJob < ActiveJob::Base
      queue_as :high_fast

      def perform(key, database_adapter)
        database_adapter.constantize.write_async(key.to_sym)
      end
    end
  end
end
