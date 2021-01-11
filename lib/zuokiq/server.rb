module Zuokiq
  class Server
    attr_accessor :queues, :concurrency

    def initialize
      @queues = Config.queues || ["default"]
      @concurrency = Etc.nprocessors
    end

    def start
      Zuokiq.logger.info "start zuokiq"
      ractor_worker

      loop do
        _, job_json = RedisClient.current.blpop(*queues_map(queues), 0)

        # Zuokiq.logger.info "[zuokiq][#{self.name}][]"
        job = JSON.parse(job_json)
        Zuokiq.logger.info "[zuokiq][#{self.name}][]"

        pipe << job
      end
    rescue Interrupt
      Zuokiq.logger.info 'Bye!'
    end

    def stop
      
    end

    private

    def ractor_worker
      @ractor_workers ||= (1..concurrency).map do
        Ractor.new(pipe) do |pipe|
          while job = pipe.take
            Ractor.yield Processor.new(job).run
          end
        end
      end
    end

    def queues_map(queues)
      queues.map{|q| "zuokiq:#{q}" }
    end

    def pipe
      @pipe ||= Ractor.new do
        loop do
          Ractor.yield Ractor.recv
        end
      end
    end

  end
end