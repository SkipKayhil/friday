# frozen_string_literal: true

module Dep
  # A wrapper class for Dependabot::Source
  class Source
    def initialize(repo:, host:)
      @repo = repo
      @host = host

      @config = Config.new(credentials: host.credentials)

      @source = Dependabot::Source.new(
        provider: host.class::PROVIDER,
        hostname: host.domain_unless_default,
        api_endpoint: host.api_endpoint,
        repo: repo.full_path,
        directory: repo.directory || '/'
      )
    end

    def fetcher(package_manager: 'bundler')
      config = @config.dup
      config.package_manager = package_manager
      config.source = self

      Fetcher.new(config: config)
    end

    def get
      @source
    end
  end
end
