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
    it '#has_shipped_orders?' do
      user = create(:user)
      address = user.addresses[0]
      user.orders.create!(name: 'Meg', address: address)

      expect(address.has_shipped_orders?).to eq(nil)

      user.orders.create!(name: 'Meg', address: address, status: 'shipped')

      expect(address.has_shipped_orders?).to eq(true)
    end
  end
end
