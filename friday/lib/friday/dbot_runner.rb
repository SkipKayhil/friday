# frozen_string_literal: true

require_relative "./dbot_runner/ruby"

module Friday
  # A wrapper for Dependabot tasks
  class DbotRunner
    def initialize(app)
      @app = app
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

    # TODO: put this on the app. Using a var for now so its easier to replace
    # in the future
    PACKAGE_MANAGER = "bundler"

    def repo
      @app.repo
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
        api_endpoint: host.api_endpoint,
        repo: repo.full_path,
        directory: repo.directory || "/"
      )
    end

    def fetcher
      @fetcher ||= Dependabot::FileFetchers.for_package_manager(PACKAGE_MANAGER).new(
        source: source,
        credentials: credentials
      )
    end

    def parser
      @parser ||= Dependabot::FileParsers.for_package_manager(PACKAGE_MANAGER).new(
        dependency_files: fetcher.files,
        source: source,
        credentials: credentials
      )
    end
  end
end
