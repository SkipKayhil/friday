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

    def ruby_version
      lockfile_ruby = @parser.send(:parsed_lockfile).ruby_version

      return lockfile_ruby if lockfile_ruby

      ruby_version = @config.fetcher.get.send(:fetch_file_if_present, '.ruby-version')

      ruby_version.content
    end

    def dependencies
      parsed_deps = {}
      @parser.parse.each do |dep|
        parsed_deps[dep.name] = { version: dep.version }
      end

      parsed_deps
    end
  end
end
