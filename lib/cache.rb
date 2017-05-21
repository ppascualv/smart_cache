module SmartCache
  module Cache
    extend self

    def read(entry)
      database_adapter.read(entry)
    end

    def write(entry)
      SmartCache::Jobs::UpdateCacheJob.perform_later(entry.key.to_s, database_adapter.to_s)
    end

    def deprecate_by_model(model)
      entries = SmartCache::Config.entries_by_model(model)
      entries.each { |entry| write(entry) }
    end

    private

    def database_adapter
      "SmartCache::Databases::#{SmartCache::Config::Database.adapter}".constantize
    end

  end
end