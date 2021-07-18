# frozen_string_literal: true

class FetchDependenciesJob < ApplicationJob
  queue_as :default

  def perform(app)
    runner = Friday::DbotRunner.new(app)

    app.dependencies.update(runner.dependencies)

    # TODO: use language_version on app instead of ruby_version on repo
    app.repo.ruby_version = runner.language_version

    app.repo.save!
  end
end
