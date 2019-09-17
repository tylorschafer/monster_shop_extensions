class Order <ApplicationRecord
  validates_presence_of :name, :status

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user
  belongs_to :address
  belongs_to :coupon, optional: true

  enum status: { pending: 0, packaged: 1, shipped: 2 , cancelled: 3 }

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def items_count
    item_orders.sum(:quantity)
  end

  def my_items_count(merchant_id)
    item_orders.joins(:item).where("items.merchant_id = #{merchant_id}").sum("item_orders.quantity")
  end

  def my_total(merchant_id)
    item_orders.joins(:item).where("items.merchant_id = #{merchant_id}").sum("item_orders.quantity * item_orders.price")
  end

  def merchant_items(merchant)
    items.where(merchant_id: merchant.id)
  end

  def qty_item_in_order(item)
    item_orders.find_by(item_id: item.id).quantity
  end

  def find_item_status(item)
    item_orders.find_by(item_id: item.id).status
  end

  def update_status
    self.update(status: 1) if item_orders.pluck(:status).all? {|status| status == "fulfilled"}
  end

  def has_coupon?
   self.coupon != nil
  end

  def discounted_total
    coupon = self.coupon
    discounts(coupon)
  end

  def discounts(coupon)
    merchant_total = item_orders.joins(:item).where("items.merchant_id = #{coupon.merchant.id}").sum('item_orders.price * item_orders.quantity')
    if coupon.coupon_type == 'percentage'
       new_total = merchant_total * (coupon.rate / 10)
    else
      new_total = merchant_total - coupon.rate
      if new_total < 0
         new_total = 0
      end
    end
    new_total
  end
end
