class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def fulfill(quantity)
    self.inventory -= quantity
    self.update(active?: false) if self.inventory == 0
    self.save
  end

  def restock(qty)
    self.inventory += qty
    self.update(active?: true) if self.inventory > 0
    self.save
  end

  def self.top_or_bottom_5(order)
    Item.left_joins(:item_orders)
      .select('items.id, items.name, coalesce(sum(item_orders.quantity), 0) as total_quantity')
      .group('items.id')
      .order("total_quantity #{order}, items.name")
      .limit(5)
  end

  def self.active_items
    Item.where(active?: true)
  end

  def update_activity
    if self.active? == true
      self.update(active?: false)
      self.save
    elsif self.active? == false
      self.update(active?: true)
      self.save
    end
  end
end
