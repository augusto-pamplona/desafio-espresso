# frozen_string_literal: true

module Api
  module V1
    class ClientsController < ApplicationController
      def create
        # company_id é somente um integer recebido pela API, não existe ainda entidade Company
        ActiveRecord::Base.transaction do
          client = Client.find_or_initialize_by(company_id: client_params[:company_id])

          client.erp_key = client_params[:erp_key]
          client.erp_secret = client_params[:erp_secret]

          if client.save
            OmieCredentialsWorker.perform_async(client.attributes.except("created_at", "updated_at"))

            render json: { "message" => "Client created and OMIE validate credential initialized", "client" => client.attributes }, status: :created
          else
            render json: { "message" => "Client not created", "errors" => client.errors.full_messages }, status: :unprocessable_entity
          end
        end
      rescue StandardError => e
        render json: { "error" => e.message }, status: :internal_server_error
      end

      private

      def client_params
        params.permit(:company_id, :erp_key, :erp_secret)
      end
    end
  end
end
