require 'rails_helper'

describe Address do
  describe 'validations' do
    it {should validate_presence_of :nickname}
    it {should validate_presence_of :street}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
  end

  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many :orders}
  end

  describe 'instance methods' do
    before :each do

    end
    it '#has_order?' do
      user = create(:user)
      address = user.addresses[0]
      order_1 = user.orders.create!(name: 'Meg', address: address)

      expect(address.has_order?).to eq(true)
    end
  end
end
