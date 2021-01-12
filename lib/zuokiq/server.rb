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
      # handle_thread_jobs

      loop do
        _, job_json = RedisClient.current.blpop(*queues_map(queues), 0)
        
        job = Zuokiq::Job.factory(job_json)
        job.performing

        pipe << job
      end
    rescue Interrupt
      Zuokiq.logger.info 'Bye!'
    end

    private

    def ractor_worker
      @ractor_workers ||= (1..concurrency).map do
        Ractor.new(pipe) do |pipe|
          while job = pipe.take
            Ractor.yield job.run
          end
        end
      end
    end

    # def handle_thread_jobs
    #   semaphore = Mutex.new
    #   counter = 0
    #   Thread.new do
    #     while counter < concurrency && job = pipe.take
    #       semaphore.synchronize { counter += 1 }
    #       Thread.new do
    #         job.run
    #         semaphore.synchronize { counter -= 1 }
    #       end
    #     end
    #   end
    # end

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