module SmartCache
  module Config
    module Database
      extend self
      attr_accessor :url
      attr_accessor :adapter
    end
  end
end