# frozen_string_literal: true

class OmieCredentialsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(client_params)
    execute_job(client_params)
  end

  private

  def execute_job(client_params)
    omie_service = OmieService.new(client_params)
    max_retries = 5
    attempts = 0
    response = nil

    while attempts < max_retries
      attempts += 1

      response = omie_service.check_credentials

      break unless response.code == 500

      sleep(3)
    end

    WebhookService.new(client_params, response).send_notify_credentials_validation
  end
end
