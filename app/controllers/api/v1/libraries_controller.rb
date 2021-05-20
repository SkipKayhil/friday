# frozen_string_literal: true

module Api
  module V1
    # REST API for interacting with Libraries
    class LibrariesController < ApplicationController
      before_action :set_library, only: %i[show update destroy]

      # GET /libraries
      def index
        @libraries = Library.all

        render json: @libraries.as_json(include: :repo)
      end

      # GET /libraries/1
      def show
        render json: @library.as_json(include: :repo)
      end

      # POST /libraries
      def create
        @library = Library.new(library_params)

        if @library.save
          render json: @library, status: :created, location: api_v1_app_url(@library)
        else
          render json: @library.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /libraries/1
      def update
        if @library.update(library_params)
          render json: @library
        else
          render json: @library.errors, status: :unprocessable_entity
        end
      end

      # DELETE /libraries/1
      def destroy
        @library.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_library
        @library = Library.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def library_params
        params.require(:library).permit(repo_attributes: %i[name full_path directory host_id])
      end
    end
  end
end
