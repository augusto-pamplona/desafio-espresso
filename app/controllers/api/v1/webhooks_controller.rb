# frozen_string_literal: true

module Api
  module V1
    class WebhooksController < ApplicationController
      before_action :set_client

      def create
        # Necessário que já exista um cliente cadastrado
        # kind são a finalidade do webhok client: 1, bill: 2, refund: 3
        return render json: { "message" => "Client must exist" }, status: :not_found unless @client

        ActiveRecord::Base.transaction do
          webhook = Webhook.find_or_initialize_by(client: @client, kind: webhook_params[:kind].present? ? webhook_params[:kind].to_i : nil)

          webhook.url = webhook_params[:url]

          if webhook.save
            render json: { "message" => "Webhook created", "webhook" => webhook.attributes }, status: :created
          else
            render json: { "message" => "Webhook not created", "errors" => webhook.errors.full_messages }, status: :unprocessable_entity
          end
        end
      rescue StandardError => e
        render json: { "error" => e.message }, status: :internal_server_error
      end

      def index
        if @client
          render json: { "webhooks" => @client&.webhooks }, status: :ok
        else
          render json: { "message" => "Client must exist" }, status: :not_found
        end
      end

      private

      def webhook_params
        params.permit(:client_id, :url, :kind)
      end

      def set_client
        @client = Client.find_by(id: webhook_params[:client_id])
      end
    end
  end
end
