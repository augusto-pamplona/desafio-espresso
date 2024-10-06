# == Schema Information
#
# Table name: bills
#
#  id              :bigint           not null, primary key
#  account_code    :string
#  category_code   :string
#  client_code     :string
#  cost            :float
#  due_date        :string
#  error_from_omie :text
#  omie_code       :bigint
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  client_id       :bigint           not null
#
# Indexes
#
#  index_bills_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
class Bill < ApplicationRecord
  belongs_to :client

  scope :submitted,    -> { where(status: "submitted") }

  # sent: Enviado para OMIE
  # submitted: Criado conta a pagar no OMIE
  # error: Algo de errado, seja antes ou durante OMIE
  # paid: Omie deu baixa na conta a pagar
  enum status: { sent: 0, submitted: 1, error: 2, paid: 3 }

  validates :client, presence: true
  validates :client_code, presence: true
  validates :category_code, presence: true
  validates :account_code, presence: true
  validates :due_date, presence: true
  validates :cost, presence: true
  validates :status, presence: true

  validates :cost, numericality: { greater_than_or_equal_to: 0 }
end
