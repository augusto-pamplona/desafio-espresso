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
class Webhook < ApplicationRecord
  belongs_to :client

  validates :client, presence: true
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }
  validates :kind, presence: true

  enum :kind, { default: 0, client: 1, bill: 2, refund: 3 }
end
