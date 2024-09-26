class CreateBills < ActiveRecord::Migration[7.2]
  def change
    create_table :bills do |t|
      t.references :client, null: false, foreign_key: true
      t.string :client_code
      t.string :category_code
      t.string :account_code
      t.string :due_date
      t.float :cost

      t.timestamps
    end
  end
end
