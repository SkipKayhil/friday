# frozen_string_literal: true

module Dep
  # A wrapper class for Dependabot::FileFetcher
  class Fetcher
    def initialize(config:)
      unless config.package_manager.in? %w[bundler]
        raise "Invalid package_manager provided to Dep::Fetcher - #{config.package_manager}"
      end

      @config = config
      @fetcher = Dependabot::FileFetchers.for_package_manager(config.package_manager).new(
        source: config.source.get,
        credentials: config.credentials
      )
    end

    def get
      @fetcher
    end

    def parser
      config = @config.dup
      config.fetcher = self

      Parser.new(config: config)
    end
  end
end
