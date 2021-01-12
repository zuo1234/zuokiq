module Zuokiq
  class Processor
    attr_accessor :klass, :data

    def initialize(klass, data)
      @klass = Object.const_get(klass)
      @data = data
    end

    def run
      klass.new.perform(*data)
    end
  end
end