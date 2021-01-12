module Zuokiq
  module Worker

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :queue

      def perform_async(data)
        queue_name = self.queue || "default"
        job = Zuokiq::Job.new(self.name, data)
        job.enqueue(queue_name)
      end

      def queue_as(queue_name)
        self.instance_variable_set(:@queue, queue_name)
      end
    end


  end
end