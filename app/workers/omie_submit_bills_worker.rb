# frozen_string_literal: true

class OmieSubmitBillsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(bill_params)
    execute_job(bill_params)
  end

  private

  def execute_job(bill_params)
    bill = Bill.find(bill_params["id"])
    omie_service = OmieService.new(bill_params)
    max_retries = 5
    attempts = 0
    response = nil

    while attempts < max_retries
      attempts += 1

      response = omie_service.submit_bill

      break unless response.code == 500

      sleep(3)
    end

    if response.success?
      bill.submitted!
    else
      bill.error_from_omie = response
      bill.error!
    end

    bill.save

    bill_params = bill.as_json(except: [ :created_at, :updated_at ]).merge({ company_id: bill.client.company_id })

    WebhookService.new(bill_params, response).send_notify_bill_submitted
  end
end
