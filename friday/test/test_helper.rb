# frozen_string_literal: true

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

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

module ActiveSupport
  class TestCase
    teardown do
      Friday.redis.flushdb
    end

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    parallelize_setup do |worker|
      # One db per process, so mid-test flushes don't affect other processes
      # To prevent flushing the dev db, 1 is added to worker index
      Friday.redis.select(worker + 1)
    end
  end
end
