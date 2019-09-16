class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :addresses, :address, :street
  end
end
