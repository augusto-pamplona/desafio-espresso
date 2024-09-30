class Webhook < ApplicationRecord
  belongs_to :client

  validates :client, presence: true
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }
  validates :kind, presence: true

  enum :kind, { default: 0, client: 1, bill: 2, refund: 3 }
end
