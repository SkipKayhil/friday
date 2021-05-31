# frozen_string_literal: true

require 'test_helper'

class App
  class DependenciesTest < ActiveSupport::TestCase
    Gem = Struct.new(:name, :version)

    setup do
      repo = repos(:friday_repo)
      @app = repo.app
    end

    test 'adding new dependencies' do
      assert_empty @app.dependencies.to_h

      @app.dependencies.update([Gem.new(rails.name, rails.version)])

      assert_app_depends_on(rails)
    end

    test 'updates existing dependencies with replacement' do
      @app.dependencies.update([Gem.new(rails6.name, rails6.version)])

      assert_app_depends_on(rails6)

      @app.dependencies.update([Gem.new(rails.name, rails.version)])

      assert_app_depends_on(rails)
      assert_empty rails6.dependents
    end

    test 'removes existing dependencies without replacement' do
      @app.dependencies.update([Gem.new(rails.name, rails.version)])

      assert_app_depends_on(rails)

      @app.dependencies.update([])

      assert_empty @app.dependencies.to_h
      assert_empty rails.dependents
    end

    private

    def rails
      @rails ||= Dependency.new(name: 'rails', version: '6.1.3.2', language: 'ruby')
    end

    def rails6
      @rails6 ||= Dependency.new(name: 'rails', version: '6.0.3.7', language: 'ruby')
    end

    def assert_app_depends_on(dependency)
      assert_equal({ dependency.name => dependency }, @app.dependencies.to_h)
      assert_equal [@app.id.to_s], dependency.dependents
    end
  end
end
