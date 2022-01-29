# frozen_string_literal: true

require "test_helper"

module Friday
  class LanguageTest < ActiveSupport::TestCase
    test ".for_package_manager" do
      expectations = [
        ["bundler", "ruby"],
        ["maven", "java"],
        ["gradle", "java"]
      ]

      expectations.each do |package_manager, expected_language|
        assert_equal expected_language, Language.for_package_manager(package_manager)
      end
    end
  end
end
