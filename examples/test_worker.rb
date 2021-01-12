require "zuokiq"

Zuokiq::Config.configure do |config|
  config.queues = %i[default high medium low]
  config.redis_url = 'redis://127.0.0.1:6379/0'
  config.redis_password = nil
end

class TestWorker
  include Zuokiq::Worker

  queue_as :default

  def perform(name)
    p "hello #{name}"
  end  
end