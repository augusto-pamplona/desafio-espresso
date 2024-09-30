FactoryBot.define do
  factory :bill do
    association :client
    client_code { "client_code_example" }
    category_code { "category_code_example" }
    account_code { "account_code_example" }
    due_date { Date.today + 99.days }
    cost { 150.0 }
  end
end
