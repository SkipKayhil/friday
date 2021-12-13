# frozen_string_literal: true

require "test_helper"

module Friday
  class FetchDependenciesJobTest < ActiveJob::TestCase
    test "app dependencies are updated" do
      project = friday_projects(:friday_app)

      VCR.use_cassette("friday_repository") do
        FetchDependenciesJob.perform_now(project)
      end

      project.reload

      assert_equal "3.0.1", project.language_version

      assert_not_empty project.dependencies
    end
  end
end
