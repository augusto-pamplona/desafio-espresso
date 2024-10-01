# == Schema Information
#
# Table name: clients
#
#  id         :bigint           not null, primary key
#  erp_key    :string
#  erp_secret :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer
#
class Client < ApplicationRecord
  has_many :bills
  has_many :webhooks

  validates :company_id, presence: true
  validates :erp_key, presence: true
  validates :erp_secret, presence: true
end
