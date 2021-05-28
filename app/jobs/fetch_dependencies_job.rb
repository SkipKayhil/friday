# frozen_string_literal: true

class FetchDependenciesJob < ApplicationJob
  queue_as :default

  def perform(app)
    app.repo.update_dependencies
  end
end
