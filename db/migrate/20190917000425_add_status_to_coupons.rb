class AddStatusToCoupons < ActiveRecord::Migration[5.1]
  def change
    add_column :coupons, :status, :integer, default: 0
  end
end
