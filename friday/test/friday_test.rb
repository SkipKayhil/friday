# frozen_string_literal: true

require "test_helper"

class FridayTest < ActiveSupport::TestCase
  test "redis doesn't use database 0 in test env" do
    assert_not_equal 0, Friday.redis._client.db
  end
end
