module Zuokiq
  class RedisClient
    def self.current
      @redis_client ||= Redis.new(
        url: Config.redis_url,
        password: Config.redis_password
      )
    end
  end
end
