require 'rails_helper'

module Api
  module V1
    RSpec.describe ClientsController, type: :controller do
      let(:valid_attributes) { attributes_for(:client) }
      let(:invalid_attributes) { { company_id: nil, erp_key: nil, erp_secret: nil } }

      describe 'POST #create' do
        context 'when the request is valid' do
          it 'creates a new Client and returns a success message' do
            expect {
              post :create, params: valid_attributes
            }.to change(Client, :count).by(1)

            expect(response).to have_http_status(:created)
            json_response = JSON.parse(response.body)
            expect(json_response['message']).to eq('Client created')
            expect(json_response['client']['company_id']).to eq(valid_attributes[:company_id])
          end
        end

        context 'when the request is invalid' do
          it 'does not create a new Client and returns error messages' do
            post :create, params: invalid_attributes

            expect(response).to have_http_status(:unprocessable_entity)
            json_response = JSON.parse(response.body)
            expect(json_response['message']).to eq('Client not created')
            expect(json_response['errors']).to include("Company can't be blank")
          end
        end

        context 'when an exception occurs' do
          before do
            allow(Client).to receive(:find_or_initialize_by).and_raise(StandardError, 'Unexpected error')
          end

          it 'returns an error message with status 500' do
            post :create, params: valid_attributes

            expect(response).to have_http_status(:internal_server_error)
            json_response = JSON.parse(response.body)
            expect(json_response['error']).to eq('Unexpected error')
          end
        end
      end
    end
  end
end
