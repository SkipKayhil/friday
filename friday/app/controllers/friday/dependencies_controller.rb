require_dependency "friday/application_controller"

module Friday
  class DependenciesController < ApplicationController
    # GET /dependencies
    def index
      @dependencies = Dependency.all

      render json: @dependencies
    end

    # GET /dependencies/:language/:name
    def show
      if params[:language] != 'ruby' || params[:name].include?(':')
        return render json: {}, status: :bad_request
      end

      @dependency = Dependency.new(params[:language], params[:name])

      render json: @dependency.with_dependents
    end
  end
end
