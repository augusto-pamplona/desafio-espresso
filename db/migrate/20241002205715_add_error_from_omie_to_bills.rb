class AddErrorFromOmieToBills < ActiveRecord::Migration[7.2]
  def change
    add_column :bills, :error_from_omie, :text
  end
end
