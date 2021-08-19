# frozen_string_literal: true

require "test_helper"

module Friday
  class Project
    class DependenciesTest < ActiveSupport::TestCase
      setup do
        @project = friday_projects(:friday_app)
      end

      test "adding new dependencies" do
        assert_empty @project.dependencies

        @project.dependencies.update([rails_six_one])

        assert_app_depends_on(rails_six_one)
      end

      test "updates existing dependencies with replacement" do
        @project.dependencies.update([rails_six])

        assert_app_depends_on(rails_six)

        @project.dependencies.update([rails_six_one])

        assert_app_depends_on(rails_six_one)
        assert_empty rails_six.dependents
      end

      test "removes existing dependencies without replacement" do
        @project.dependencies.update([rails_six_one])

        assert_app_depends_on(rails_six_one)

        @project.dependencies.update([])

        assert_empty @project.dependencies
        assert_empty rails_six_one.dependents
        assert_empty rails.versions
        assert_empty Friday::Dependency.all
      end

      private

      def rails
        @rails ||= Friday::Dependency.new("ruby", "rails")
      end

      def rails_six_one
        @rails_six_one ||= rails.at("6.1.3.2")
      end

      def rails_six
        @rails_six ||= rails.at("6.0.3.7")
      end

      def assert_app_depends_on(versioned)
        assert_equal [versioned], @project.dependencies.to_hash
        assert_equal [@project.id.to_s], versioned.dependents
        assert_equal [versioned.version], versioned.dependency.versions
        assert_equal [versioned.dependency], Friday::Dependency.all
      end
    end
  end
end
