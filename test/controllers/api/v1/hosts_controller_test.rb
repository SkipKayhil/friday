# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class HostsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @host = hosts(:github)
      end

      test 'should get index' do
        get api_v1_hosts_url, as: :json
        assert_response :success
      end

      test 'should create host' do
        assert_difference('Host.count') do
          post api_v1_hosts_url, params: { host: { domain: @host.domain, token: @host.token, type: @host.type } },
                                 as: :json
        end

        assert_response 201
      end

      test 'should show host' do
        get api_v1_host_url(@host), as: :json
        assert_response :success
      end

      test 'should update host' do
        patch api_v1_host_url(@host), params: { host: { domain: @host.domain, token: @host.token, type: @host.type } },
                                      as: :json
        assert_response 200
      end

      test 'should destroy host' do
        assert_difference('Host.count', -1) do
          delete api_v1_host_url(@host), as: :json
        end

        assert_response 204
      end
    end
  end
end
