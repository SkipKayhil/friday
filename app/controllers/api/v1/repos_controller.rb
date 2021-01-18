# frozen_string_literal: true

module Api
  module V1
    # REST API for interacting with Repositories
    class ReposController < Api::ApplicationController
      before_action :set_repo, only: %i[show update destroy]

      # GET /repos
      def index
        @repos = Repo.all

        render json: @repos
      end

      # GET /repos/1
      def show
        render json: @repo
      end

      # POST /repos
      def create
        @repo = Repo.new(repo_params)

        if @repo.save
          render json: @repo, status: :created, location: api_v1_repo_url(@repo)
        else
          render json: @repo.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /repos/1
      def update
        if @repo.update_dependencies
          render json: @repo
        else
          render json: @repo.errors, status: :unprocessable_entity
        end
      end

      # DELETE /repos/1
      def destroy
        @repo.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_repo
        @repo = Repo.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def repo_params
        params.require(:repo).permit(:full_path, :directory)
      end
    end
  end
end
