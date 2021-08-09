# frozen_string_literal: true

require "test_helper"

module Friday
  class ProjectTest < ActiveSupport::TestCase
    test "language inferred from package_manager" do
      project = friday_projects(:friday_app)

      assert_equal "ruby", project.language
    end
  end
end
