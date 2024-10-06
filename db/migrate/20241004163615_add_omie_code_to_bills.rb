class AddOmieCodeToBills < ActiveRecord::Migration[7.2]
  def change
    add_column :bills, :omie_code, :bigint
  end
end
