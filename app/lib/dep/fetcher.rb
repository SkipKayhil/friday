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

    def parse_ruby_version
      lockfile = @fetcher.send(:lockfile).content
      ruby = Bundler::LockfileParser.new(lockfile).ruby_version

      return ruby if ruby

      ruby_version = @fetcher.send(:fetch_file_if_present, '.ruby-version')

      ruby_version.content
    end
  end
end
