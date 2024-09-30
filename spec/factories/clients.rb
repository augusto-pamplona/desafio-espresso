FactoryBot.define do
  factory :client do
    company_id { rand(999) }
    erp_key { "erp_key_example" }
    erp_secret { "erp_secret_example" }
  end
end
