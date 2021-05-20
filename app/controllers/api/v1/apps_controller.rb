# frozen_string_literal: true

module Api
  module V1
    # REST API for interacting with Apps
    class AppsController < Api::ApplicationController
      before_action :set_app, only: %i[show update destroy]

      # GET /apps
      def index
        @apps = App.all

        render json: @apps.as_json(include: :repo)
      end

      # GET /apps/1
      def show
        render json: @app.as_json(include: :repo)
      end

      # POST /apps
      def create
        @app = App.new(app_params)

        if @app.save
          render json: @app, status: :created, location: api_v1_app_url(@app)
        else
          render json: @app.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /apps/1
      def update
        if @app.update_dependencies
          render json: @app
        else
          render json: @app.errors, status: :unprocessable_entity
        end
      end

      # DELETE /apps/1
      def destroy
        @app.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_app
        @app = App.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def app_params
        params.require(:app).permit(repo_attributes: %i[name full_path directory host_id])
      end
    end
  end
end
