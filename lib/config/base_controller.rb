module SmartCache
  module Config
    module BaseController
      extend self
      attr_accessor :controller

      def controller
        @controller ||= ApplicationController
      end
    end
  end
end
