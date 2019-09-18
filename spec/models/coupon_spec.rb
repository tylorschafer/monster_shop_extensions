require 'rails_helper'

describe Coupon do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_uniqueness_of :name}
    it {should validate_numericality_of :rate}
  end

  describe 'relationships' do
    it {should have_many :orders}
    it {should belong_to :merchant}
  end

  describe 'instance methods' do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @sue = @dog_shop.users.create(name: 'Sue', email: 'sue@email.com', password: 'sue', password_confirmation: 'sue', role: 3)
    end
    it '#has_orders?' do
      user = create(:user)
      coupon_1 = create(:coupon, merchant: @dog_shop)

      expect(coupon_1.has_orders?).to eq(false)

      order = create(:order, user: user, coupon: coupon_1, address: user.addresses[0])

      expect(coupon_1.has_orders?).to eq(true)
    end
  end
end
