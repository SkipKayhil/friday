# frozen_string_literal: true

module Dep
  # A wrapper class for Dependabot::FileFetcher
  class Fetcher
    def initialize(artifacts)
      unless artifacts.package_manager.in? %w[bundler]
        raise "Invalid package_manager provided to Dep::Fetcher - #{artifacts.package_manager}"
      end

      @fetcher = Dependabot::FileFetchers.for_package_manager(artifacts.package_manager).new(
        source: artifacts.source,
        credentials: artifacts.credentials
      )

      @artifacts = artifacts
      @artifacts.fetcher = @fetcher
    end

    def get
      @fetcher
    end

    def parser
      @parser ||= Parser.new(@artifacts)
    end
  end
end
