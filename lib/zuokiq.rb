# frozen_string_literal: true
require "json"
require "redis"
require 'securerandom'
require_relative "zuokiq/config"
require_relative "zuokiq/job"
require_relative "zuokiq/logger"
require_relative "zuokiq/processor"
require_relative "zuokiq/redis_client"
require_relative "zuokiq/server"
require_relative "zuokiq/worker"
require_relative "zuokiq/version"

module Zuokiq
  class Error < StandardError; end
  # Your code goes here...
  def self.configure(&block)
    Config.configure(&block)
  end

  def self.logger
    Logger::LOGGER
  end
end
