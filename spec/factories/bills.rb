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
FactoryBot.define do
  factory :bill do
    association :client
    status { :sent }
    client_code { "client_code_example" }
    category_code { "category_code_example" }
    account_code { "account_code_example" }
    due_date { Date.today + 99.days }
    cost { 150.0 }
  end
end
