# frozen_string_literal: true

module Api
  module V1
    # REST API for interacting with Hosts
    class HostsController < ApplicationController
      before_action :set_host, only: %i[show update destroy]

      # GET /hosts
      def index
        @hosts = Host.all

        render json: @hosts
      end

      # GET /hosts/1
      def show
        render json: @host
      end

      # POST /hosts
      def create
        @host = Host.new(host_params)

        if @host.save
          render json: @host, status: :created, location: api_v1_host_url(@host)
        else
          render json: @host.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /hosts/1
      def update
        if @host.update(host_params)
          render json: @host
        else
          render json: @host.errors, status: :unprocessable_entity
        end
      end

      # DELETE /hosts/1
      def destroy
        @host.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_host
        @host = Host.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def host_params
        params.require(:host).permit(:type, :domain, :token)
      end
    end
  end
end
