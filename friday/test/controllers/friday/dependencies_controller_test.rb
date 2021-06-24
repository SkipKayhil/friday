# frozen_string_literal: true

require 'test_helper'

module Friday
  class DependenciesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test 'should get index' do
      get dependencies_url, as: :json
      assert_response :success
    end

    test 'should show dependency' do
      get dependency_url(language: 'ruby', name: 'rails'), as: :json
      assert_response :success
    end

    test 'should error on invalid language or name' do
      get dependency_url(language: 'notruby', name: 'rails'), as: :json
      assert_response :bad_request

      get dependency_url(language: 'ruby', name: 'rails:injected'), as: :json
      assert_response :bad_request
    end
  end
end
