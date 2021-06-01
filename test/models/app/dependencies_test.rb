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

      @app.dependencies.update([rails])

      assert_app_depends_on(rails)
    end

    test 'updates existing dependencies with replacement' do
      @app.dependencies.update([rails6])

      assert_app_depends_on(rails6)

      @app.dependencies.update([rails])

      assert_app_depends_on(rails)
      assert_empty rails6.dependents
    end

    test 'removes existing dependencies without replacement' do
      @app.dependencies.update([rails])

      assert_app_depends_on(rails)

      @app.dependencies.update([])

      assert_empty @app.dependencies.to_h
      assert_empty rails.dependents
    end

    private

    def rails
      @rails ||= Dependency.new('ruby', 'rails', '6.1.3.2')
    end

    def rails6
      @rails6 ||= Dependency.new('ruby', 'rails', '6.0.3.7')
    end

    def assert_app_depends_on(dependency)
      assert_equal({ dependency.name => dependency }, @app.dependencies.to_h)
      assert_equal [@app.id.to_s], dependency.dependents
    end
  end
end
