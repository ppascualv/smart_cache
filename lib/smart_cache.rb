require "smart_cache/version"
#redis-rails needed

module SmartCache
  extend self

  #autoload :Jobs, "#{Rails.root}/app/smart_cache/smart_cache/jobs/update_cache_job"

  def self.config(&block)
    if block_given?
      block.call(SmartCache::Config)
    else
      SmartCache::Config
    end
    initialize_cache!
  end

  def initialize_cache!
    puts 'Initialize cache'
    SmartCache::Config.entries.each do |entry|
      puts "Key: #{entry.key}"
      value = SmartCache::Cache.read(entry)
      if value.nil?
        SmartCache::Cache.write(entry)
      end
    end
  end
end