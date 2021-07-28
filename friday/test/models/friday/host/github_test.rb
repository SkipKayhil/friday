# frozen_string_literal: true

require "test_helper"
require_relative "../host_test"

module Friday
  class Host
    class GithubTest < ActiveSupport::TestCase
      include Friday::HostTest

      def setup
        @host = friday_hosts(:github)
      end
    end
  end
end
