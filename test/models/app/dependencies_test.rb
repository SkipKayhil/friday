# frozen_string_literal: true

require 'test_helper'

class App
  class DependenciesTest < ActiveSupport::TestCase
    setup do
      repo = repos(:friday_repo)
      @app = repo.app
    end

    test 'adding new dependencies' do
      assert_empty @app.dependencies.to_h

      @app.dependencies.update([rails_six_one])

      assert_app_depends_on(rails_six_one)
    end

    test 'updates existing dependencies with replacement' do
      @app.dependencies.update([rails_six])

      assert_app_depends_on(rails_six)

      @app.dependencies.update([rails_six_one])

      assert_app_depends_on(rails_six_one)
      assert_empty rails_six.dependents
    end

    test 'removes existing dependencies without replacement' do
      @app.dependencies.update([rails_six_one])

      assert_app_depends_on(rails_six_one)

      @app.dependencies.update([])

      assert_empty @app.dependencies.to_h
      assert_empty rails_six_one.dependents
      assert_empty rails.versions
      assert_empty Friday::Dependency.all
    end

    private

    def rails
      @rails ||= Friday::Dependency.new('ruby', 'rails')
    end

    def rails_six_one
      @rails_six_one ||= rails.at('6.1.3.2')
    end

    def rails_six
      @rails_six ||= rails.at('6.0.3.7')
    end

    def assert_app_depends_on(versioned)
      assert_equal({ versioned.name => versioned }, @app.dependencies.to_h)
      assert_equal [@app.id.to_s], versioned.dependents
      assert_equal [versioned.version], versioned.dependency.versions
      assert_equal [versioned.dependency], Friday::Dependency.all
    end
  end
end
