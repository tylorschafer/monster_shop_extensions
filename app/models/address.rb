class Address < ApplicationRecord
  validates_presence_of :street, :city, :state, :zip, :nickname

  belongs_to :user
  has_many :orders

  def has_shipped_orders?
    shipped_orders = orders.find_by(status: 'shipped')
    return true if shipped_orders
  end
end
