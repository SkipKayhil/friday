# frozen_string_literal: true

module Dep
  # A wrapper class for Dependabot::Source
  class Source
    def initialize(repo:, host:)
      @source = Dependabot::Source.new(
        provider: host.class::PROVIDER,
        hostname: host.domain_unless_default,
        api_endpoint: host.api_endpoint,
        repo: repo.full_path,
        directory: repo.directory || '/'
      )

      @artifacts = Artifacts.new(
        "bundler",
        [host.credentials],
        @source
      )
    end

    def fetcher
      Fetcher.new(@artifacts)
    end

    def get
      @source
    end
  end
end
