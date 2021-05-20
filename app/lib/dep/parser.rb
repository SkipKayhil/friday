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
      full_ruby_version.match(/\d+\.\d+\.\d+/)
    end

    def dependencies
      parsed_deps = {}
      @parser.parse.each do |dep|
        parsed_deps[dep.name] = { version: dep.version, known_vulnerability: audit[dep.name] }
      end

      parsed_deps
    end

    def audit
      @audit ||= @parser.send(:parsed_lockfile).specs.map do |gem|
        known_vulnerability = false

        database.check_gem(gem) do |advisory|
          known_vulnerability = true
        end

        [gem.name, known_vulnerability]
      end.to_h
    end

    private

    def database
      @database ||= begin
        if Bundler::Audit::Database.exists?
          Bundler::Audit::Database.update!
        else
          Bundler::Audit::Database.download
        end

        Bundler::Audit::Database.new
      end
    end

    def full_ruby_version
      lockfile_ruby = Bundler::LockfileParser.new(@parser.send(:lockfile).content).ruby_version

      return lockfile_ruby if lockfile_ruby

      ruby_version = @config.fetcher.get.send(:fetch_file_if_present, '.ruby-version')

      ruby_version.content
    end
  end
end
