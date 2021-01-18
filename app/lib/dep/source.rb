# frozen_string_literal: true

module Dep
  # A wrapper class for Dependabot::Source
  class Source
    def initialize(repo:, directory: '/', branch: nil, type: :gitlab)
      @repo = repo
      @directory = directory
      @branch = branch

      case type
      when :gitlab
        @source = gitlab
        @config = Config.new(credentials: Env::Gitlab.credentials)
      else
        raise "Invalid type provided to Dep::Source - #{type}"
      end
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
      gitlab_hostname = Env::Gitlab.hostname

      Dependabot::Source.new(
        provider: 'gitlab',
        hostname: gitlab_hostname,
        api_endpoint: "https://#{gitlab_hostname}/api/v4",
        repo: @repo,
        directory: @directory,
        branch: @branch
      )
    end
  end
end
