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

  it "can add items to contents" do
    cart = Cart.new(nil)
    cart.add_item("7")
    expect(cart.contents).to eq({"7"=>1})
    cart.add_item("7")
    expect(cart.contents).to eq({"7"=>2})
    cart.add_item("2")
    expect(cart.contents).to eq({"7"=>2, "2"=>1})
  end

  it "can add item quantity" do
    cart = Cart.new(nil)
    cart.add_item("7")
    cart.add_quantity("7")
    cart.add_quantity("7")
    expect(cart.contents).to eq({"7"=>3})
  end

  it "can subtract item quantity" do
    cart = Cart.new({"7"=>3})
    cart.subtract_quantity("7")
    cart.subtract_quantity("7")
    expect(cart.contents).to eq({"7"=>1})
  end

  it "can check item quantity" do
    cart = Cart.new({"7"=>3})
    expect(cart.quantity_of("7")).to eq(3)
  end

  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 3)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 2)
    @cart = Cart.new({@pull_toy.id.to_s => 1, @dog_bone.id.to_s => 2})
  end

  it "can calculate subtotals" do
    expect(@cart.subtotal(@pull_toy)).to eq(10)
    expect(@cart.subtotal(@dog_bone)).to eq(42)
  end

  it "can calculate order total" do
    expect(@cart.total).to eq(52)
  end

  it '#items' do
    expect(@cart.items).to eq({@pull_toy => 1, @dog_bone => 2})
  end

  it '#limit_reached?' do
    expect(@cart.limit_reached?(@pull_toy.id)).to be(false)
    @cart = Cart.new({@pull_toy.id.to_s => 3, @dog_bone.id.to_s => 2})
    expect(@cart.limit_reached?(@pull_toy.id)).to be(true)
  end

  it '#quantity_zero?' do
    expect(@cart.quantity_zero?(@pull_toy.id)).to be(false)
    @cart = Cart.new({@pull_toy.id.to_s => 0, @dog_bone.id.to_s => 2})
    expect(@cart.quantity_zero?(@pull_toy.id)).to be(true)
  end
  it "#discounts" do
    coupon = create(:coupon, coupon_type: :percent, rate: 10, merchant: @dog_shop)
    expect(@cart.discounts(coupon).to_f).to eq(5.20)

    coupon_2 = create(:coupon, coupon_type: :dollar, rate: 10, merchant: @dog_shop)
    expect(@cart.discounts(coupon_2).to_f).to eq(10)

    coupon_3 = create(:coupon, coupon_type: :dollar, rate: 100, merchant: @dog_shop)
    expect(@cart.discounts(coupon_3).to_f).to eq(52)
    expect(@cart.discounted_total(coupon_3)).to eq(0)
  end

  it "#discounted_total" do
    coupon_3 = create(:coupon, coupon_type: :dollar, rate: 100, merchant: @dog_shop)
    expect(@cart.discounted_total(coupon_3)).to eq(0)
  end
end
