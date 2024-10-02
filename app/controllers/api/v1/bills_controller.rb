# frozen_string_literal: true

module Api
  module V1
    class BillsController < ApplicationController
      before_action :set_client

      def create
        if Webhook.where(company_id: @client.company_id, kind: 2).empty?
          return render json: { "message" => "Your company_id must have a webhook with kind 2, check the documentation" }, status: :unprocessable_entity
        end
        ActiveRecord::Base.transaction do
          bill = Bill.find_or_initialize_by(bill_params)

          bill.status = :sent
          if bill.save
            if bill.status != "submitted"
              bill_attributes = bill.as_json(except: [ :created_at, :updated_at ])
              client_attributes = bill.client.as_json(except: [ :created_at, :updated_at, :id ])
              mixed_attributes = bill_attributes.merge(client_attributes)

              OmieSubmitBillsWorker.perform_async(mixed_attributes)
              bill.sent!
            end

            render json: { "message" => "Bill created and sent to OMIE, you will receive information in your webhook kind: 2", "bill" => bill.attributes }, status: :created
          else
            render json: { "message" => "Bill not created", "errors" => bill.errors.full_messages }, status: :unprocessable_entity
          end
        end
      rescue StandardError => e
        render json: { "error" => e.message }, status: :internal_server_error
      end

      def index
        render json: { "bills" => @client.bills }, status: :ok
      end

      private

      def bill_params
        params.require(:bill).permit(:account_code, :category_code, :client_code, :cost, :due_date, :client_id)
      end

      def set_client
        @client = Client.find(bill_params[:client_id].present? ? bill_params[:client_id].to_i : nil)
      end
    end
  end
end
