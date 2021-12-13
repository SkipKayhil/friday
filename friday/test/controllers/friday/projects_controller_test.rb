# frozen_string_literal: true

require "test_helper"

module Friday
  class ProjectsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @project = friday_projects(:friday_app)
    end

    test "should get index" do
      get projects_url, as: :json
      assert_response :success
    end

    test "should create project" do
      assert_difference("Project.count") do
        post projects_url, params: {project: {directory: @project.directory, language_version: @project.language_version, name: @project.name, package_manager: @project.package_manager, repository_id: @project.repository_id}}, as: :json
      end

      assert_response 201
    end

    test "should show project" do
      get project_url(@project), as: :json
      assert_response :success
    end

    test "should update project" do
      patch project_url(@project), params: {project: {directory: @project.directory, language_version: @project.language_version, name: @project.name, package_manager: @project.package_manager, repository_id: @project.repository_id}}, as: :json
      assert_response 200
    end

    test "should destroy project" do
      assert_difference("Project.count", -1) do
        delete project_url(@project), as: :json
      end

      assert_response 204
    end

    test "should enqueue FetchDependenciesJob" do
      assert_enqueued_with(job: FetchDependenciesJob, args: [@project]) do
        post dependencies_project_url(@project)
      end
    end
  end
end
