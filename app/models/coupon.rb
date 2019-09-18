class Coupon < ApplicationRecord
  has_many :orders
  belongs_to :merchant

  validates :name, presence: true, uniqueness: true
  validates_numericality_of :rate, greater_than: 0

  enum coupon_type: { percent: 1, dollar: 2}
  enum status: { active: 0, inactive: 1}

  def has_orders?
    orders.count(:id) > 0
  end
end
