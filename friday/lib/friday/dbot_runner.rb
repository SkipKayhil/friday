# frozen_string_literal: true

require_relative "./dbot_runner/ruby"

module Friday
  # A wrapper for Dependabot tasks
  class DbotRunner
    def initialize(project)
      @project = project
    end

    def dependencies
      parser.parse
    end

    def language_version
      # TODO: make this work with non-ruby apps
      Ruby.new(self).version
    end

    def file(name)
      # TODO: see if Dependabot would accept a PR to cache this method
      # an alternative would be to just monkey patch it now...
      fetcher.send(:fetch_file_if_present, name)&.content
    end

    private

    def repo
      @project.repository
    end

    def host
      repo.host
    end

    def credentials
      [host.credentials]
    end

    def source
      @source ||= Dependabot::Source.new(
        provider: host.class::PROVIDER,
        hostname: host.domain_unless_default,
        api_endpoint: host.endpoint_unless_default,
        repo: repo.full_path,
        directory: @project.directory || "/"
      )
    end

    def fetcher
      @fetcher ||= Dependabot::FileFetchers.for_package_manager(@project.package_manager).new(
        source: source,
        credentials: credentials
      )
    end

    def parser
      @parser ||= Dependabot::FileParsers.for_package_manager(@project.package_manager).new(
        dependency_files: fetcher.files,
        source: source,
        credentials: credentials
      )
    end
  end
end
