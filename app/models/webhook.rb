class Webhook < ApplicationRecord
  belongs_to :client

  validates :client, presence: true
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }
  validates :kind, presence: true, inclusion: { in: [ 0, 1, 2 ], message: "is not a valid kind" }

  enum kind: { notify: 1, warning: 2 }
end
