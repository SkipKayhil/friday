# frozen_string_literal: true

class FetchDependenciesJob < ApplicationJob
  queue_as :default

  def perform(app)
    parser = Dep::Source.new(repo: app.repo, host: app.repo.host).fetcher.parser

    app.dependencies.update(parser.parse)

    # Keep updating the repo's dependencies for now, but this will be removed
    # once the Redis implementation is used everywhere
    app.repo.ruby_version = parser.ruby_version
    app.repo.dependencies = parser.dependencies_with_audit

    app.repo.save!
  end
end
