class Coupon < ApplicationRecord
  has_many :orders
  belongs_to :merchant

  validates :name, presence: true, uniqueness: true
  validates_numericality_of :rate, greater_than: 0
  validates_numericality_of :chance, greater_than: 0

  enum type: { percent_off: 1, dollar_off: 2}
end
