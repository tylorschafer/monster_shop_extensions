class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


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

  def self.top_5
    top_ids = ActiveRecord::Base.connection.execute("select id, amount_purchased from (select items.id, items.name, sum(quantity) as amount_purchased from items inner join item_orders on items.id = item_orders.item_id group by items.id order by amount_purchased desc limit 5) as item_id")
    items = {}
    top_ids.each do |hash|
      items[Item.find(hash["id"])] = hash["amount_purchased"]
    end
    items
  end

  def self.bottom_5
    bottom_ids = ActiveRecord::Base.connection.execute("select id, amount_purchased from (select items.id, items.name, sum(quantity) as amount_purchased from items inner join item_orders on items.id = item_orders.item_id group by items.id order by amount_purchased asc limit 5) as item_id")
    items = {}
    bottom_ids.each do |hash|
      items[Item.find(hash["id"])] = hash["amount_purchased"]
    end
    items
  end

end
