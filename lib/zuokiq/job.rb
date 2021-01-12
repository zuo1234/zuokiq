module Zuokiq
  class Job
    attr_accessor :klass, :data, :id

    def initialize(klass, data, id = nil)
      @klass = klass
      @data = data
      @id = id || SecureRandom.uuid
    end

    # 传入job的json数据，返回job对象
    def self.factory(json_str)
      job_hash = JSON.parse(json_str)
      self.new(job_hash['klass'], job_hash['data'], job_hash['id'])
    end

    # 进入队列
    def enqueue(queue_name)
      Zuokiq.logger.info "enqueue #{klass} (Job ID:#{self.id})"
      RedisClient.current.rpush("zuokiq:#{queue_name}", {'klass' => self.klass, 'data' => data, 'id' => id}.to_json)
    end

    # 出队列
    def performing
      Zuokiq.logger.info "performing #{klass} (Job ID:#{self.id})"
    end

    # 执行
    def run
      Processor.new(klass, data).run
      Zuokiq.logger.info "performed #{klass} (Job ID:#{self.id})"
    end

  end
end