# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class AppsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @repo = repos(:friday_repo)
      end

      test 'should get index' do
        get api_v1_apps_url, as: :json
        assert_response :success
      end

      test 'should create app' do
        assert_difference('App.count') do
          post api_v1_apps_url, params: { app: { repo_attributes: {
            full_path: @repo.full_path, host_id: @repo.host_id
          } } }, as: :json
        end

        assert_response 201
      end

      test 'should show app' do
        get api_v1_app_url(@repo.repoable), as: :json
        assert_response :success
      end

      test 'should update app' do
        patch api_v1_app_url(@repo.repoable), params: { app: {
          repo_attributes: { directory: '/frontend' }
        } }, as: :json
        assert_response 200
      end

      test 'should destroy app' do
        assert_difference('App.count', -1) do
          delete api_v1_app_url(@repo.repoable), as: :json
        end

        assert_response 204
      end

      test 'should enqueue FetchDependenciesJob' do
        assert_enqueued_with(job: FetchDependenciesJob, args: [@repo.app]) do
          post dependencies_api_v1_app_url(@repo.app)
        end
      end
    end
  end
end
