class Client < ApplicationRecord
  has_many :bills
  has_many :webhooks

  validates :company_id, presence: true
  validates :erp_key, presence: true
  validates :erp_secret, presence: true
end
