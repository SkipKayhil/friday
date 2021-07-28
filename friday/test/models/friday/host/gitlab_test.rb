# frozen_string_literal: true

require "test_helper"
require_relative "../host_test"

module Friday
  class Host
    class GitlabTest < ActiveSupport::TestCase
      include Friday::HostTest

      def setup
        @host = friday_hosts(:gitlab)
      end
    end
  end
end
