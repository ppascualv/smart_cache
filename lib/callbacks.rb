module SmartCache
  module Callbacks
    extend self

    def add_after_save(entry)
      entry.models.each do |model|
        model.class_eval do
          after_save :deprecate_cache
          after_destroy :deprecate_cache

          def deprecate_cache
            puts "Cache deprecated"
            SmartCache::Cache.deprecate_by_model(self.class)
          end
        end
      end
    end

    def add_render_to_base_controller
      SmartCache::Config::BaseController.controller.class_eval do
        before_action :cached

        def cached
          if params[:cached_value].present?
            puts "Cache HIT!"
            render json: params[:cached_value], status: :ok
          end
        end
      end
    end
  end
end
