# frozen_string_literal: true

require "zuokiq"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Zuokiq::Config.configure do |config|
  config.queues = %i[default high medium low]
  config.redis_url = 'redis://127.0.0.1:6379/0'
end