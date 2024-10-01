require 'rails_helper'

module Api
  module V1
    RSpec.describe WebhooksController, type: :controller do
      let(:client) { create(:client) }
      let(:webhook) { create(:webhook, client: client) }
      let(:valid_attributes) { { client_id: client.id, url: 'http://example.com', kind: 1 } }
      let(:invalid_attributes) { { client_id: client.id, url: nil, kind: nil } }

      describe 'POST #create' do
        context 'when the request is valid' do
          it 'creates a new Webhook and returns a success message' do
            expect {
              post :create, params: valid_attributes
            }.to change(Webhook, :count).by(1)

            expect(response).to have_http_status(:created)
            json_response = JSON.parse(response.body)
            expect(json_response['message']).to eq('Webhook created')
            expect(json_response['webhook']['client_id']).to eq(client.id)
            expect(json_response['webhook']['url']).to eq('http://example.com')
            expect(json_response['webhook']['kind']).to eq("client")
          end
        end

        context 'when the client does not exist' do
          it 'returns a 404 not found error' do
            post :create, params: { client_id: 0, url: 'http://example.com', kind: 1 }

            expect(response).to have_http_status(:not_found)
            json_response = JSON.parse(response.body)
            expect(json_response['message']).to eq('Client must exist')
          end
        end

        context 'when the request is invalid' do
          it 'does not create a Webhook and returns error messages' do
            post :create, params: invalid_attributes

            expect(response).to have_http_status(:unprocessable_entity)
            json_response = JSON.parse(response.body)
            expect(json_response['message']).to eq('Webhook not created')
            expect(json_response['errors']).to include("Url can't be blank", "Kind can't be blank")
          end
        end

        context 'when an exception occurs' do
          before do
            allow(Webhook).to receive(:find_or_initialize_by).and_raise(StandardError, 'Unexpected error')
          end

          it 'returns a 500 error with the exception message' do
            post :create, params: valid_attributes

            expect(response).to have_http_status(:internal_server_error)
            json_response = JSON.parse(response.body)
            expect(json_response['error']).to eq('Unexpected error')
          end
        end
      end

      describe 'GET #index' do
        context 'when the client exists and has webhooks' do
          before do
            webhook
          end

          it 'returns the client\'s webhooks with a 200 status' do
            get :index, params: { client_id: client.id }

            expect(response).to have_http_status(:ok)
            json_response = JSON.parse(response.body)
            expect(json_response['webhooks'].length).to eq(1)
            expect(json_response['webhooks'].first['id']).to eq(webhook.id)
            expect(json_response['webhooks'].first['url']).to eq(webhook.url)
          end
        end

        context 'when the client exists but has no webhooks' do
          it 'returns an empty list with a 200 status' do
            get :index, params: { client_id: client.id }

            expect(response).to have_http_status(:ok)
            json_response = JSON.parse(response.body)
            expect(json_response['webhooks']).to be_empty
          end
        end

        context 'when the client does not exist' do
          it 'returns a 404 not found error' do
            get :index, params: { client_id: 0 }

            expect(response).to have_http_status(:not_found)
            json_response = JSON.parse(response.body)
            expect(json_response['message']).to eq('Client must exist')
          end
        end
      end
    end
  end
end
