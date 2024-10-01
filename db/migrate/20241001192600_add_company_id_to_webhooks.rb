class AddCompanyIdToWebhooks < ActiveRecord::Migration[7.2]
  def change
    add_column :webhooks, :company_id, :integer
    change_column_null :webhooks, :client_id, true
  end
end
