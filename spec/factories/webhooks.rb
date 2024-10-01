# == Schema Information
#
# Table name: webhooks
#
#  id         :bigint           not null, primary key
#  kind       :integer
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#
# Indexes
#
#  index_webhooks_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
FactoryBot.define do
  factory :webhook do
    association :client
    url { "https://example.com/webhook" }
    kind { :client }
  end
end
