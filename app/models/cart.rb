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

  def discounted_total(coupon)
    if coupon.coupon_type = 'percent'
      total * (1 - (coupon.rate / 100))
    else
      new_total = total - coupon.rate
      if new_total < 0
        new_total = 0 
      end
    end
  end
end
