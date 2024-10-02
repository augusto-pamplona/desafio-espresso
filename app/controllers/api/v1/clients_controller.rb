# frozen_string_literal: true

module Api
  module V1
    class ClientsController < ApplicationController
      def create
        # company_id é somente um integer recebido pela API, não existe ainda entidade Company
        if Webhook.where(company_id: client_params[:company_id], kind: 1).empty?
          return render json: { "message" => "Your company_id must have a webhook with kind 1, check the documentation" }, status: :unprocessable_entity
        end

        ActiveRecord::Base.transaction do
          client = Client.find_or_initialize_by(company_id: client_params[:company_id])
          client.assign_attributes(erp_key: client_params[:erp_key], erp_secret: client_params[:erp_secret])

          if client.save
            OmieCredentialsWorker.perform_async(client.as_json(except: [ :created_at, :updated_at ]))
            render json: { "message" => "Client created and OMIE validate credential initialized, you will receive information in your webhook kind: 1", "client" => client.attributes }, status: :created
          else
            render json: { "message" => "Client not created", "errors" => client.errors.full_messages }, status: :unprocessable_entity
          end
        end
      rescue StandardError => e
        render json: { "error" => e.message }, status: :internal_server_error
      end

      private

      def client_params
        params.require(:client).permit(:company_id, :erp_key, :erp_secret)
      end
    end
  end
end
