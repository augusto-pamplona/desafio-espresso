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
FactoryBot.define do
  factory :client do
    company_id { rand(999) }
    erp_key { "erp_key_example" }
    erp_secret { "erp_secret_example" }
  end
end
