module SmartCache
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      puts request.path
      puts request.params
      if request.get?
        entry = SmartCache::Config.lookup_entry_by_path(request.path)
        if entry && !request.params['smart_cache']
          puts "Cache detected!"
          cached_value = SmartCache::Cache.read(entry)
          request.update_param('cached_value', cached_value)
        end
      end
      @app.call(env)
    end
  end
end
