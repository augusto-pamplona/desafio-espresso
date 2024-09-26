class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.integer :company_id
      t.string :erp_key
      t.string :erp_secret

      t.timestamps
    end
  end
end
