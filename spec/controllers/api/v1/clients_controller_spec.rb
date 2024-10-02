require 'rails_helper'

module Api
  module V1
    RSpec.describe ClientsController, type: :controller do
      let(:valid_attributes) { attributes_for(:client) }
      let(:webhook) { create(:webhook, company_id: valid_attributes[:company_id], kind: 1) }
      let(:invalid_attributes) { { company_id: nil, erp_key: nil, erp_secret: nil } }

      before do
        allow(OmieCredentialsWorker).to receive(:perform_async)
      end

      describe 'POST #create' do
        context 'when the request is valid' do
          before do
            webhook
          end

          it 'creates a new Client and returns a success message' do
            expect {
              post :create, params: { client: valid_attributes }
            }.to change(Client, :count).by(1)

            expect(response).to have_http_status(:created)
            json_response = JSON.parse(response.body)
            expect(json_response['message']).to eq('Client created and OMIE validate credential initialized, you will receive information in your webhook kind: 1')
            expect(json_response['client']['company_id']).to eq(valid_attributes[:company_id])
          end

          it 'creates a new Client and enqueues the OmieCredentialsWorker' do
            expect(OmieCredentialsWorker).to receive(:perform_async).with(hash_including("company_id" => valid_attributes[:company_id]))

            post :create, params: { client: valid_attributes }

            expect(response).to have_http_status(:created)
          end
        end

        context 'when the request is invalid' do
          it 'does not create a new Client and returns error messages' do
            post :create, params: { client: invalid_attributes }

            expect(response).to have_http_status(:unprocessable_entity)
            json_response = JSON.parse(response.body)
            expect(json_response['message']).to eq('Your company_id must have a webhook with kind 1, check the documentation')
          end
        end

        context 'when an exception occurs' do
          before do
            webhook
            allow(Client).to receive(:find_or_initialize_by).and_raise(StandardError, 'Unexpected error')
          end

          it 'returns an error message with status 500' do
            post :create, params: { client: valid_attributes }

            expect(response).to have_http_status(:internal_server_error)
            json_response = JSON.parse(response.body)
            expect(json_response['error']).to eq('Unexpected error')
          end
        end
      end
    end
  end
end
