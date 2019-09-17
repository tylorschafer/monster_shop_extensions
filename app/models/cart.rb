class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def quantity_of(item_id)
    @contents[item_id.to_s].to_i
  end

  def add_quantity(item_id)
    @contents[item_id.to_s] = quantity_of(item_id) + 1
  end

  def subtract_quantity(item_id)
    @contents[item_id.to_s] = quantity_of(item_id) - 1
  end

  def total_items
    num_items = @contents.values.map(&:to_i).sum
    @contents.empty? ? 0 : num_items
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    @contents[item.id.to_s].to_i * item.price
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def limit_reached?(item_id)
    @contents[item_id.to_s] == Item.find(item_id).inventory
  end

  def quantity_zero?(item_id)
    @contents[item_id.to_s] == 0
  end

  def discounts(coupon)
    merchant_id = coupon.merchant.id
    if coupon.coupon_type == 'percent'
      apply_percentage_discount(coupon, merchant_id)
    else
      apply_dollar_discount(coupon, merchant_id)
    end
  end

  def apply_percentage_discount(coupon, merchant_id)
    discounted_total = 0
    @contents.each do |item_id,quantity|
      item = Item.find_by(merchant_id: merchant_id, id: item_id)
      if item
        item_price = item.price
        discounted_total += (item_price * (coupon.rate / 100)) * quantity
      end
    end
    discounted_total
  end

  def apply_dollar_discount(coupon, merchant_id)
    merchant_total = 0
    @contents.each do |item_id,quantity|
      item = Item.find_by(merchant_id: merchant_id, id: item_id)
      merchant_total += (item.price * quantity) if item
    end
    if merchant_total - coupon.rate < 0
      merchant_total
    else
      coupon.rate
    end
  end

  def discounted_total(coupon)
    total - discounts(coupon)
  end
end
