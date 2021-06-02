# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'webmock/minitest'
WebMock.disable_net_connect!

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/cassettes'
  config.hook_into :webmock
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
      Friday.redis.select(worker)
    end

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
