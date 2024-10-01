# == Schema Information
#
# Table name: bills
#
#  id            :bigint           not null, primary key
#  account_code  :string
#  category_code :string
#  client_code   :string
#  cost          :float
#  due_date      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  client_id     :bigint           not null
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

  validates :client, presence: true
  validates :client_code, presence: true
  validates :category_code, presence: true
  validates :account_code, presence: true
  validates :due_date, presence: true
  validates :cost, presence: true

  validates :cost, numericality: { greater_than_or_equal_to: 0 }
end
