# frozen_string_literal: true

module Dep
  # A wrapper class for Dependabot::FileParsers
  class Parser
    def initialize(config:)
      @config = config
      @parser = Dependabot::FileParsers.for_package_manager(config.package_manager).new(
        dependency_files: config.fetcher.get.files,
        source: config.source.get,
        credentials: config.credentials
      )
    end

    def get
      @parser
    end
  end
end
