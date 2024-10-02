class AddStatusToBills < ActiveRecord::Migration[7.2]
  def change
    add_column :bills, :status, :integer
  end
end
