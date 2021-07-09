# frozen_string_literal: true

require 'test_helper'

class FetchDependenciesJobTest < ActiveJob::TestCase
  test 'app dependencies are updated' do
    repo = repos(:friday_repo)

    VCR.use_cassette('friday_repository') do
      FetchDependenciesJob.perform_now(repo.app)
    end

    repo.reload

    assert_equal '3.0.1', repo.ruby_version

    assert_not_empty repo.app.dependencies
  end
end
