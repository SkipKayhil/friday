# frozen_string_literal: true

require_dependency 'friday/application_controller'

module Friday
  class DependenciesController < ApplicationController
    # GET /dependencies
    def index
      @dependencies = Dependency.all

      render json: @dependencies
    end

    # GET /dependencies/:language/:name
    def show
      return render json: {}, status: :bad_request if params[:language] != 'ruby' || params[:name].include?(':')

      @dependency = Dependency.new(params[:language], params[:name])

      render json: @dependency.with_dependents
    end
  end
end
