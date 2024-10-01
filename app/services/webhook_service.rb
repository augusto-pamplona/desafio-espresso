# frozen_string_literal: true

class WebhookService
  def initialize(client_params, response_params)
    @client_params = client_params.with_indifferent_access
    @response_params = response_params
  end

  def send_notify_credentials_validation
    # Webhook kind: 1 - client for credentials validation
    body = build_body
    webhook = Webhook.find_by(company_id: @client_params["company_id"], kind: 1)

    HTTParty.post(webhook.url, body: body.to_json) if webhook.present?
  end

  private

  def build_body
    if @response_params.success?
      { message: "Credentials validated", status: :ok }
    else
      { message: "Credentials not validated", status: @response_params.code }
    end
  end
end
