# spec/controllers/api/v1/bills_controller_spec.rb

require 'rails_helper'

module Api
  module V1
    RSpec.describe BillsController, type: :controller do
      let(:client) { create(:client) } # Create a client for association
      let(:valid_attributes) do
        {
          account_code: 'ACC123',
          category_code: 'CAT456',
          client_code: 'CLI789',
          cost: 100.0,
          due_date: '2024-10-01',
          client_id: client.id
        }
      end

      let(:invalid_attributes) { { account_code: nil, cost: nil, client_id: client.id } }

      describe 'POST #create' do
        context 'when the webhook exists for the client' do
          before do
            create(:webhook, company_id: client.company_id, kind: 2)
            allow(OmieSubmitBillsWorker).to receive(:perform_async)
          end

          context 'with valid attributes' do
            it 'creates a new Bill and returns a success message' do
              expect {
                post :create, params: { bill: valid_attributes }
              }.to change(Bill, :count).by(1)

              expect(response).to have_http_status(:created)
              json_response = JSON.parse(response.body)
              expect(json_response['message']).to eq('Bill created and sent to OMIE, you will receive information in your webhook kind: 2')
              expect(json_response['bill']['account_code']).to eq(valid_attributes[:account_code])
            end

            it 'enqueues the OmieSubmitBillsWorker with correct attributes' do
              post :create, params: { bill: valid_attributes }

              expect(OmieSubmitBillsWorker).to have_received(:perform_async).with(hash_including(
                "account_code" => valid_attributes[:account_code],
                "category_code" => valid_attributes[:category_code],
                "client_code" => valid_attributes[:client_code],
                "cost" => valid_attributes[:cost],
                "due_date" => valid_attributes[:due_date]
              ))

              post :create, params: { bill: valid_attributes }

              expect(response).to have_http_status(:created)
            end
          end

          context 'with invalid attributes' do
            it 'does not create a new Bill and returns error messages' do
              post :create, params: { bill: invalid_attributes }

              expect(response).to have_http_status(:unprocessable_entity)
              json_response = JSON.parse(response.body)
              expect(json_response['message']).to eq('Bill not created')
              expect(json_response['errors']).to include("Account code can't be blank", "Cost can't be blank")
            end
          end
        end

        context 'when the webhook does not exist for the client' do
          it 'returns an error message' do
            post :create, params: { bill: valid_attributes }

            expect(response).to have_http_status(:unprocessable_entity)
            json_response = JSON.parse(response.body)
            expect(json_response['message']).to eq('Your company_id must have a webhook with kind 2, check the documentation')
          end
        end
      end

      describe 'GET #index' do
        it 'returns a list of bills for the client' do
          create(:bill, client: client)
          create(:bill, client: client)

          get :index, params: { bill: { client_id: client.id } }

          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response['bills'].count).to eq(2)
        end
      end
    end
  end
end
