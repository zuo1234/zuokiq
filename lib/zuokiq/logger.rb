require "logger"

# Ruby logger formatter is not Ractor-friendly. 
class Logger::Formatter
  def call(severity, time, progname, msg)
    Format % [
      severity[0..0],
      format_datetime(time),
      Process.pid,
      severity,
      progname,
      msg2str(msg)
    ]
  end
end


class Rogger < Ractor
  def self.new
    super do
      logger = ::Logger.new($stdout)
 
      while data = recv
        logger.public_send(data[0], *data[1])
      end
    end
  end
 
  def method_missing(m, *args, &_block)
    self << [m, *args]
  end
end

module Zuokiq
  class Logger < ::Logger
    LOGGER = Rogger.new
  end
end