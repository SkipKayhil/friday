# frozen_string_literal: true

require "test_helper"

module Friday
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @repository = friday_repositories(:rails_rails)
    end

    test "should get index" do
      get repositories_url, as: :json
      assert_response :success
    end

    test "should create repository" do
      assert_difference("Repository.count") do
        post repositories_url, params: {repository: {full_path: @repository.full_path, host_id: @repository.host_id}}, as: :json
      end

      assert_response 201
    end

    test "should show repository" do
      get repository_url(@repository), as: :json
      assert_response :success
    end

    test "should update repository" do
      patch repository_url(@repository), params: {repository: {full_path: @repository.full_path, host_id: @repository.host_id}}, as: :json
      assert_response 200
    end

    test "should destroy repository" do
      assert_difference("Repository.count", -1) do
        delete repository_url(@repository), as: :json
      end

      assert_response 204
    end
  end
end
