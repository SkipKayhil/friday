# frozen_string_literal: true

require "test_helper"

module Friday
  class HostsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @host = friday_hosts(:gitlab)
    end

    test "should get index" do
      get hosts_url, as: :json
      assert_response :success
    end

    test "should create host" do
      assert_difference("Host.count") do
        post hosts_url, params: {host: {domain: @host.domain, token: @host.token, type: @host.type}}, as: :json
      end

      assert_response 201
    end

    test "should show host" do
      get host_url(@host), as: :json
      assert_response :success
    end

    test "should update host" do
      patch host_url(@host), params: {host: {domain: @host.domain, token: @host.token, type: @host.type}}, as: :json
      assert_response 200
    end

    test "should destroy host" do
      assert_difference("Host.count", -1) do
        delete host_url(@host), as: :json
      end

      assert_response 204
    end
  end
end
