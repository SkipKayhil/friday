# frozen_string_literal: true

module Friday
  class FetchDependenciesJob < ApplicationJob
    queue_as :default

    def perform(project)
      runner = Friday::DbotRunner.new(project)

      project.dependencies.update(runner.dependencies)

      project.language_version = runner.language_version

      project.save! if project.changed?
    end
  end
end
