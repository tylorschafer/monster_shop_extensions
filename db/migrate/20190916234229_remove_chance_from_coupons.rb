class RemoveChanceFromCoupons < ActiveRecord::Migration[5.1]
  def change
    remove_column :coupons, :chance, :decimal
  end
end
