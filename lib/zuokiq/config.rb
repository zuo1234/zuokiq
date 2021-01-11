module Zuokiq
  class Config
    class << self
      attr_accessor :queues, :redis_url, :redis_password

      def configure
        yield self
      end
    end

  end
end