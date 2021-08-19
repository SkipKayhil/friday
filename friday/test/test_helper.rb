# frozen_string_literal: true

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require "simplecov"
SimpleCov.start "rails" do
  enable_coverage :branch
end

require_relative "../../config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../db/migrate", __dir__)]
# Only use the dummy app's migrations because Friday's migrations are already
# included
# ActiveRecord::Migrator.migrations_paths = [File.expand_path('../db/migrate', __dir__)]
require "rails/test_help"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

# clone ruby-advisory-db before running tests to avoid git concurrency issues
Friday::RubyDB.send(:database)

module ActiveSupport
  class TestCase
    teardown do
      Friday.redis.flushdb
    end

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    parallelize_setup do |worker|
      SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
      # One db per process, so mid-test flushes don't affect other processes
      # To prevent flushing the dev db, 1 is added to worker index
      Friday.redis.select(worker + 1)
    end

    parallelize_teardown do
      SimpleCov.result
    end
  end
end
