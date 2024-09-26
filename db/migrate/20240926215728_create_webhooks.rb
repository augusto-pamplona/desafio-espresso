class CreateWebhooks < ActiveRecord::Migration[7.2]
  def change
    create_table :webhooks do |t|
      t.string :url
      t.integer :kind
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
