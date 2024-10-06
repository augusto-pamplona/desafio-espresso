# frozen_string_literal: true

class DailyOmieBillsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform
    execute_job
  end

  private

  def execute_job
    Bill.submitted.each do |bill|
      bill_attributes = bill.as_json(except: [ :created_at, :updated_at ])
      client_attributes = bill.client.as_json(except: [ :created_at, :updated_at, :id ])
      mixed_attributes = bill_attributes.merge(client_attributes)

      omie_service = OmieService.new(mixed_attributes)

      max_retries = 5
      attempts = 0
      response = nil

      while attempts < max_retries
        attempts += 1

        response = omie_service.check_bill

        break unless response.code == 500

        sleep(3)
      end

      if response.success? && response["status_titulo"] == "PAGO"
        bill.paid!
        bill.error_from_omie = nil

        WebhookService.new(mixed_attributes, response).send_paid_bill
      elsif !response.success?
        bill.error_from_omie = response
      end

      bill.save
    end
  end
end
