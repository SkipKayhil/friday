# frozen_string_literal: true

module Friday
  module HostTest
    extend ActiveSupport::Concern

    included do
      test "#credentials" do
        assert_equal @host.domain, @host.credentials["host"]
        assert_equal @host.token, @host.credentials["password"]
      end

      test "#domain_unless_default" do
        assert_nil @host.domain_unless_default

        @host.domain = "git.example.com"

        assert_equal "git.example.com", @host.domain_unless_default
      end

      test "#endpoint_unless_default" do
        assert_nil @host.endpoint_unless_default

        @host.domain = "git.example.com"

        assert_equal @host.endpoint, @host.endpoint_unless_default
      end
    end
  end
end
