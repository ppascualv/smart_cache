module SmartCache
  module Config
    class Entry
      attr_accessor :key
      attr_accessor :path
      attr_accessor :models
      attr_accessor :controller
      attr_accessor :action

      def initialize(params={})
        params.each do |attr, value|
          public_send("#{attr}=", value)
        end
      end

      def timestamp
        @timestamp ||= DateTime.now.strftime('%Q').to_i
      end

      class << self
        def view(path)
          session = ActionDispatch::Integration::Session.new(Rails.application)
          session.get path, { smart_cache: true }
          response = session.response
          raise "status #{response.status}" if response.status != 200
          response.body
          session.reset!
        end
      end
    end
  end
end
