# frozen_string_literal: true

module Dep
  # A wrapper class for Dependabot::Source
  class Source
    def initialize(repo:, host:)
      @repo = repo
      @host = host

      @config = Config.new(credentials: host.credentials)

      # case :github
      # when :github
      @source = github
      # when :gitlab
      #   @source = gitlab
      # else
      #   raise "Invalid type provided to Dep::Source - #{type}"
      # end
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

    private

    def gitlab
      gitlab_hostname = @host.domain

      Dependabot::Source.new(
        provider: 'gitlab',
        hostname: gitlab_hostname,
        api_endpoint: "https://#{gitlab_hostname}/api/v4",
        repo: @repo.full_path,
        directory: @repo.directory || '/',
        branch: nil # not implemented yet
      )
    end

    def github
      Dependabot::Source.new(
        provider: 'github',
        # hostname: @host.domain, # specifying hostname requires specifying api_endpoint
        repo: @repo.full_path,
        directory: @repo.directory || '/'
      )
    end
  end
end
