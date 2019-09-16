class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.integer :coupon_type, default: 1
      t.decimal :rate
      t.decimal :chance
      t.references :merchant, foreign_key: true
    end
  end
end
