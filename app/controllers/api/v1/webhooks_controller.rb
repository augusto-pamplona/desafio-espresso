# frozen_string_literal: true

module Api
  module V1
    class WebhooksController < ApplicationController
      def create
        # kind são a finalidade do webhok client: 1, bill: 2, refund: 3
        ActiveRecord::Base.transaction do
          webhook = Webhook.find_or_initialize_by(company_id: webhook_params[:company_id], kind: webhook_params[:kind].present? ? webhook_params[:kind].to_i : nil)

          webhook.url = webhook_params[:url]
          webhook.client_id = webhook_params[:client_id] if webhook_params[:client_id].present?

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
        if webhook_params[:company_id].blank?
          render json: { "message" => "Company_id must exist" }, status: :not_found
        else
          webhooks = Webhook.where(company_id: webhook_params[:company_id])
          render json: { "webhooks" => webhooks }, status: :ok
        end
      end

      private

      def webhook_params
        params.permit(:company_id, :client_id, :url, :kind)
      end
    end
  end
end
