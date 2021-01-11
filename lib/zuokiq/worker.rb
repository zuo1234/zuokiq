module Zuokiq
  module Worker

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :queue

      def perform_async(data)
        queue_name = self.queue || "default"
        RedisClient.current.rpush("zuokiq:#{queue_name}", {'klass' => self.name, 'data' => data}.to_json)
      end

      def queue_as(queue_name)
        self.instance_variable_set(:@queue, queue_name)
      end
    end


  end
end