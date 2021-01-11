module Zuokiq
  class Processor
    attr_accessor :klass, :data

    # job {klass: "", data: [""..]}
    def initialize(job)
      @klass = Object.const_get(job["klass"])
      @data = job["data"]
    end

    def run
      klass.new.perform(*data)
    end
  end
end