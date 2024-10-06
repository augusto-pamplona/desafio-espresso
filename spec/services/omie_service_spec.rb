# spec/services/omie_service_spec.rb

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe OmieService do
  let(:params) do
    {
      "erp_key" => "your_app_key",
      "erp_secret" => "your_app_secret",
      "client_code" => 123,
      "due_date" => "2024-12-31",
      "cost" => 1000.0,
      "category_code" => "CAT456",
      "id" => 1,
      "omie_code" => 456
    }
  end

  subject { described_class.new(params) }

  describe '#check_credentials' do
    it 'calls the add_default_user method' do
      expect(subject).to receive(:add_default_user)
      subject.check_credentials
    end
  end

  describe '#submit_bill' do
    before do
      stub_request(:post, "https://app.omie.com.br/api/v1/financas/contapagar/")
        .to_return(status: 200, body: { success: true, message: "Bill submitted" }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'submits a new bill' do
      response = subject.submit_bill
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body)["message"]).to eq("Bill submitted")
    end
  end

  describe '#check_bill' do
    before do
      stub_request(:post, "https://app.omie.com.br/api/v1/financas/contapagar/")
        .to_return(status: 200, body: { success: true, status: "Paid" }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'checks the status of a bill' do
      response = subject.check_bill
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body)["status"]).to eq("Paid")
    end
  end
end
