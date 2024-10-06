# spec/services/webhook_service_spec.rb

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WebhookService do
  let(:params) do
    {
      "company_id" => 1,
      "error_from_omie" => nil,
      "omie_code" => 456
    }
  end

  let(:response_params) do
    OpenStruct.new(success?: true, code: 200, "codigo_lancamento_omie" => 789)
  end

  subject { described_class.new(params, response_params) }

  describe '#send_notify_credentials_validation' do
    before do
      allow(Webhook).to receive(:find_by).and_return(double("Webhook", url: "http://example.com/webhook"))
      stub_request(:post, "http://example.com/webhook")
        .to_return(status: 200, body: { success: true, message: "Credentials validated" }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'sends a notification for credentials validation' do
      response = subject.send_notify_credentials_validation
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body)["message"]).to eq("Credentials validated")
    end
  end

  describe '#send_notify_bill_submitted' do
    before do
      allow(Webhook).to receive(:find_by).and_return(double("Webhook", url: "http://example.com/webhook"))
    end

    context 'when response is successful' do
      it 'sends a notification for bill submission' do
        stub_request(:post, "http://example.com/webhook")
          .to_return(status: 200, body: { success: true, message: "Bill submitted in OMIE, code: 789" }.to_json, headers: { 'Content-Type' => 'application/json' })

        response = subject.send_notify_bill_submitted
        expect(response.code).to eq(200)
        expect(JSON.parse(response.body)["message"]).to include("Bill submitted in OMIE")
      end
    end

    context 'when there is an error from OMIE' do
      let(:params) do
        {
          "company_id" => 1,
          "error_from_omie" => '{"error": "some error"}'
        }
      end

      it 'sends a notification with the error message' do
        stub_request(:post, "http://example.com/webhook")
          .to_return(status: 200, body: { success: true, message: "some error" }.to_json, headers: { 'Content-Type' => 'application/json' })

        response = subject.send_notify_bill_submitted
        expect(response.code).to eq(200)
        expect(JSON.parse(response.body)["message"]).to eq("some error")
      end
    end
  end

  describe '#send_paid_bill' do
    before do
      allow(Webhook).to receive(:find_by).and_return(double("Webhook", url: "http://example.com/webhook"))
      stub_request(:post, "http://example.com/webhook")
        .to_return(status: 200, body: { success: true, message: "Bill successfully refund for code: 456" }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'sends a notification for bill payment' do
      response = subject.send_paid_bill
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body)["message"]).to include("Bill successfully refund for code: 456")
    end
  end
end
