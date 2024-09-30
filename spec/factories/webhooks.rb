FactoryBot.define do
  factory :webhook do
    association :client
    url { "https://example.com/webhook" }
    kind { :client }
  end
end
