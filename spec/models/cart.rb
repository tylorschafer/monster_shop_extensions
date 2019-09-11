require 'rails_helper'

describe Cart do
  it "can initialize with no contents" do
    cart = Cart.new(nil)
    expect(cart.contents).to eq({})
  end

  it "can initialize with contents" do
    cart = Cart.new({"4"=>"2", "7"=>"1"})
    expect(cart.contents).to eq({"4"=>"2", "7"=>"1"})
  end

  it "can report total items in cart" do
    cart = Cart.new(nil)
    expect(cart.total_items).to eq(0)

    cart = Cart.new({"4"=>"2", "7"=>"1"})
    expect(cart.total_items).to eq(3)
  end

  # it "can report quantity of an item" do
  #   cart = Cart.new({"4"=>"2", "7"=>"1"})
  #   expect(cart.quantity_of(4)).to eq(2)
  #   expect(cart.quantity_of(7)).to eq(1)
  # end

  it "can add items to contents" do
    cart = Cart.new(nil)
    cart.add_item("7")
    expect(cart.contents).to eq({"7"=>1})
    cart.add_item("7")
    expect(cart.contents).to eq({"7"=>2})
    cart.add_item("2")
    expect(cart.contents).to eq({"7"=>2, "2"=>1})
  end

  # xit "can remove an item" do
  #   cart = Cart.new(nil)
  #   cart.add_item("7")
  #   cart.remove_item("7")
  #   expect(cart.contents).to eq({})
  # end

  it "cant add item quantity" do
    cart = Cart.new(nil)
    cart.add_item("7")
    cart.add_quantity("7")
    cart.add_quantity("7")
    expect(cart.contents).to eq({"7"=>3})
  end

  it "cant add item quantity" do
    cart = Cart.new({"7"=>3})
    cart.subtract_quantity("7")
    cart.subtract_quantity("7")
    expect(cart.contents).to eq({"7"=>1})
  end

  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @cart = Cart.new({@pull_toy.id.to_s=>1, @dog_bone.id.to_s=>2})
  end

  xit "can calculate subtotals" do
    expect(@cart.subtotal(@pull_toy.id)).to eq(10)
    expect(@cart.subtotal(@dog_bone.id)).to eq(42)
  end

  xit "can calculate order total" do
    expect(@cart.order_total).to eq(52)
  end

  xit "can reset a cart to empty" do
    @cart.empty
    expect(@cart.contents).to eq({})
  end
end
