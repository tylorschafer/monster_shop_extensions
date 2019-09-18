class ItemOrder < ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity, :status

  belongs_to :item
  belongs_to :order

  enum status: { unfulfilled: 0, fulfilled: 1 }

  def subtotal
    price * quantity
  end

  def fulfill
    item = Item.find_by(id: self.item_id)
    self.update(status: 1)
    self.save!
  end

end
