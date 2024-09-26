class Bill < ApplicationRecord
  belongs_to :client

  validates :client, presence: true
  validates :client_code, presence: true
  validates :category_code, presence: true
  validates :account_code, presence: true
  validates :due_date, presence: true
  validates :cost, presence: true

  validates :cost, numericality: { greater_than_or_equal_to: 0 }
end
