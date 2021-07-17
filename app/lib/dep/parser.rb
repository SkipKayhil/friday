# frozen_string_literal: true

module Dep
  # A wrapper class for Dependabot::FileParsers
  class Parser
    def initialize(artifacts)
      @parser = Dependabot::FileParsers.for_package_manager(artifacts.package_manager).new(
        dependency_files: artifacts.fetcher.files,
        source: artifacts.source,
        credentials: artifacts.credentials
      )
    end

    def get
      @parser
    end

    def parse
      @parse ||= @parser.parse
    end

    def ruby_version
      full_ruby_version.match(/\d+\.\d+\.\d+/)
    end

    private

    def full_ruby_version
      lockfile_ruby = Bundler::LockfileParser.new(@parser.send(:lockfile).content).ruby_version

      return lockfile_ruby if lockfile_ruby

      ruby_version = @artifacts.fetcher.send(:fetch_file_if_present, ".ruby-version")

      return ruby_version.content if ruby_version

      ""
    end
  end
end
