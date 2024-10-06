# frozen_string_literal: true

class WebhookService
  def initialize(params, response_params)
    @params = params.with_indifferent_access
    @response_params = response_params
  end

  def send_notify_credentials_validation
    send_notification(1, build_credentials_validation_body)
  end

  def send_notify_bill_submitted
    send_notification(2, build_bill_submitted_body)
  end

  def send_paid_bill
    send_notification(3, build_bill_paid_body)
  end

  private

  def send_notification(kind, body)
    webhook = Webhook.find_by(company_id: @params["company_id"], kind: kind)

    if webhook.present?
      response = HTTParty.post(webhook.url, body: body.to_json, headers: { "Content-Type" => "application/json" })
    end
  rescue StandardError => e
    Rails.logger.error("Error sending webhook notification: #{e.message}")
  end

  def build_credentials_validation_body
    {
      message: @response_params.success? ? "Credentials validated" : "Credentials not validated",
      status: @response_params.success? ? :ok : @response_params.code
    }
  end

  def build_bill_submitted_body
    bill_error_message = @params["error_from_omie"].present? ? JSON.parse(@params["error_from_omie"]).to_s : "Bill worker error"
    {
      message: @response_params.success? ? "Bill submitted in OMIE, code: #{@response_params["codigo_lancamento_omie"]}" : bill_error_message,
      status: @response_params.success? ? :ok : @response_params.code
    }
  end

  def build_bill_paid_body
    {
      message: @response_params.success? ? "Bill successfuly refund for code: #{@params["omie_code"]}" : "Error on omie request",
      status: @response_params.success? ? :ok : @response_params.code
    }
  end
end
